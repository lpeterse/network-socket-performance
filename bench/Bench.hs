{-# LANGUAGE OverloadedStrings #-}
module Main ( main ) where

import           Control.Concurrent.Async
import           Control.DeepSeq
import           Control.Monad                  (forM, forM_, when)
import qualified Data.ByteString                as BS

import qualified Network.Socket                 as N
import qualified Network.Socket.ByteString      as NBS

import qualified System.Socket                  as S
import qualified System.Socket.Family.Inet      as S
import qualified System.Socket.Protocol.Default as S
import qualified System.Socket.Type.Stream      as S

import           Criterion.Main

-------------------------------------------------------------------------------
-- You may modify these test parameters!
-------------------------------------------------------------------------------

chunk :: BS.ByteString
chunk = BS.replicate 40 23

iterations :: Int
iterations = 5000 * 1000

concurrency :: Int
concurrency = 5

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

main :: IO ()
main = defaultMain benchmarks

benchmarks :: [Benchmark]
benchmarks =
  [ bgroup ("transmission of " ++ ts ++ " (in chunks of " ++ cs ++ ") over an Inet4-TCP-Socket (half-duplex) with concurrency " ++ c) [
      bench "socket"  $ withPairsSocket  1 transmitHalfDuplexSocket
    , bench "network" $ withPairsNetwork 1 transmitHalfDuplexNetwork
    ]
  , bgroup ("transmission of " ++ ts ++ " (in chunks of " ++ cs ++ ") in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency " ++ c) [
      bench "socket"  $ withPairsSocket  1 transmitFullDuplexSocket
    , bench "network" $ withPairsNetwork 1 transmitFullDuplexNetwork
    ]
  ]
  where
    ts = showBytes totalSize
    cs = showBytes chunkSize
    c  = show concurrency

-------------------------------------------------------------------------------
-- HALF-DUPLEX
-------------------------------------------------------------------------------

transmitHalfDuplexNetwork :: NetworkPair -> IO ()
transmitHalfDuplexNetwork (s1,s2) = do
  (sent, received) <- receive 0 `concurrently` send
  when (sent /= received) $ error $
    "Sent " ++ show sent ++ ", but received " ++ show received ++ "."
  where
    send = do
      forM_ [1 .. iterations] (const $ NBS.sendAll s1 chunk)
      N.close s1
      pure (iterations * BS.length chunk)
    receive acc = do
      bs <- NBS.recv s2 1024
      if BS.null bs
        then N.close s2 >> pure acc
        else receive $! acc + BS.length bs

transmitHalfDuplexSocket :: SocketPair -> IO ()
transmitHalfDuplexSocket (s1,s2) = do
  (sent, received) <- receive 0 `concurrently` send
  when (sent /= received) $ error $
    "Sent " ++ show sent ++ ", but received " ++ show received ++ "."
  where
    send = do
      forM_ [1 .. iterations] (const $ S.sendAll s1 chunk S.msgNoSignal)
      S.close s1
      pure (iterations * BS.length chunk)
    receive acc = do
      bs <- S.receive s2 1024 S.msgNoSignal
      if BS.null bs
        then S.close s2 >> pure acc
        else receive $! acc + BS.length bs

-------------------------------------------------------------------------------
-- FULL-DUPLEX
-------------------------------------------------------------------------------

transmitFullDuplexNetwork :: NetworkPair -> IO ()
transmitFullDuplexNetwork (s1,s2) = do
  receive s1 0 `concurrently_` receive s2 0 `concurrently_` send s1 `concurrently_` send s2
  N.close s1
  N.close s2
  where
    send s =
      forM_ [1 .. iterations] (const $ NBS.sendAll s chunk)
    receive s acc
      | acc == totalSize = pure () -- finished
      | otherwise = do
          bs <- NBS.recv s 1024
          receive s $! acc + BS.length bs

transmitFullDuplexSocket :: SocketPair -> IO ()
transmitFullDuplexSocket (s1,s2) = do
  receive s1 0 `concurrently_` receive s2 0 `concurrently_` send s1 `concurrently_` send s2
  S.close s1
  S.close s2
  where
    send s =
      forM_ [1 .. iterations] (const $ S.sendAll s chunk S.msgNoSignal)
    receive s acc
      | acc == totalSize = pure () -- finished
      | otherwise = do
          bs <- S.receive s 1024 S.msgNoSignal
          receive s $! acc + BS.length bs

-------------------------------------------------------------------------------
-- Util
-------------------------------------------------------------------------------

type SocketPair = (S.Socket S.Inet S.Stream S.Default, S.Socket S.Inet S.Stream S.Default)
type NetworkPair = (N.Socket, N.Socket)

instance NFData (S.Socket f t p) where
  rnf _ = ()

instance NFData N.Socket where
  rnf _ = ()

chunkSize :: Int
chunkSize = BS.length chunk

totalSize :: Int
totalSize = iterations * chunkSize

showBytes :: Int -> String
showBytes i
  | i < 1000    = show i ++ " bytes"
  | i < 1000000 = show (div i 1000) ++ " kB"
  | otherwise   = show (div i 1000000) ++ " MB"

withPairsNetwork :: Int -> (NetworkPair -> IO ()) -> Benchmarkable
withPairsNetwork n action =
  perRunEnv createPairs (mapConcurrently_ action)
  where
    createPairs :: IO [(N.Socket, N.Socket)]
    createPairs = do
      let addr = N.SockAddrInet 8089 $ N.tupleToHostAddress (127,0,0,1)
      server <- N.socket N.AF_INET N.Stream 0
      N.setSocketOption server N.ReuseAddr 1
      N.bind server addr
      N.listen server 128
      pairs <- forM [1..n] $ const $ do
        s1 <- N.socket N.AF_INET N.Stream 0
        N.connect s1 addr
        s2 <- fst <$> N.accept server
        pure (s1, s2)
      N.close server
      pure pairs

withPairsSocket :: Int -> (SocketPair -> IO ()) -> Benchmarkable
withPairsSocket n action =
  perRunEnv createPairs (mapConcurrently_ action)
  where
    createPairs :: IO [(S.Socket S.Inet S.Stream S.Default, S.Socket S.Inet S.Stream S.Default)]
    createPairs = do
      let addr = S.SocketAddressInet S.inetLoopback 8089
      server <- S.socket
      S.setSocketOption server (S.ReuseAddress True)
      S.bind server addr
      S.listen server 128
      pairs <- forM [1..n] $ const $ do
        s1 <- S.socket
        S.connect s1 addr
        s2 <- fst <$> S.accept server
        pure (s1, s2)
      S.close server
      pure pairs
