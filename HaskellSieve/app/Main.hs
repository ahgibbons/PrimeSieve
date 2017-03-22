{-# LANGUAGE FlexibleContexts #-}
module Main where

import Data.Array.MArray
import Data.Array.IO
import Data.Array.ST
import Control.Monad.ST
import Data.Array.Unboxed
import Control.Monad
import System.IO
import System.Environment (getArgs)

main :: IO ()
main = mainIO 
--main = mainST

mainST :: IO ()
mainST = do
  [n',outdir] <- getArgs
  let n      = read n' :: Int
      primes = primeSieveST n
  writeFile outdir (unlines . map show $ primes)
  putStrLn "Primes found using STUArray"

mainIO :: IO ()
mainIO = do
  [n',outdir] <- getArgs
  let n      = read n' :: Int
  primes <- primeSieveIO n
  writeFile outdir (unlines . map show $ primes)
  putStrLn "Primes found using IOUArray"

-- Prime sieve using IOUArray
primeSieveIO :: Int -> IO [Int]
primeSieveIO n = do
  arr <- newArray (1,n) True :: IO (IOUArray Int Bool)
  writeArray arr 1 False
  let p=2
  forM_ [p..n] $ \a -> do
              v <- readArray arr a
              if v then markOff arr a n
                   else return ()
  iarr <- freeze arr :: IO (UArray Int Bool)
  return . map fst . filter (\(_,a)-> a) $ assocs iarr

-- Prime sieve using STUArray
primeSieveST :: Int -> [Int]
primeSieveST n = map fst . filter (\(_,a) -> a) . assocs $ runSTUArray $ do
  arr <- newArray (1,n) True
  writeArray arr 1 False
  let p = 2
  forM_ [p..n] $ \a -> do
      v <- readArray arr a
      if v then markOff arr a n 
           else return ()
  return arr


markOff :: (Integral i,Ix i, MArray a Bool m)  => a i Bool -> i -> i -> m ()
markOff arr a n = do
  forM_ [2*a,2*a+a..n] $ \b -> writeArray arr b False 

