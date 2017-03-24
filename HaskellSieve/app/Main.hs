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

{-
main :: IO ()
--main = mainIO 
main = mainST
-}

import Criterion
import Criterion.Main

main = do
  n <- readLn
  defaultMain
    [ bench "io"  $ nfIO (primeSieveIO n)
    , bench "st"  $ nf primeSieveST n
    , bench "st2" $ nf primeSieveST2 n
    , bench "uo"  $ nf primesToUO n
    ]

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
      if v then markOffST arr a n 
           else return ()
  return arr


primeSieveSTA :: Int -> UArray Int Bool
primeSieveSTA n = runSTUArray $ do
  arr <- newArray (1,n) True :: ST s (STUArray s Int Bool)
  writeArray arr 1 False
  let p = 2 :: Int
  forM_ [p..n] $ \a -> do
      v <- readArray arr a
      when v $ do
        forM_ [2*a, 2*a + a..n] $ \b ->
          writeArray arr b False
  return arr

primeSieveST2 :: Int -> [Int]
primeSieveST2 n = [a | (a,True) <- assocs $ primeSieveSTA n]

sieveUO :: Int -> UArray Int Bool
sieveUO m = runSTUArray $ do
    sieve <- newArray (1,m) True          -- :: ST s (STUArray s Int Bool)
    writeArray sieve 1 False
    forM_ [2..m] $ \i -> do               -- prime(i) = 2i+1
      isPrime <- readArray sieve i        -- ((2i+1)^2-1)`div`2 = 2i(i+1)
      when isPrime $ do                   
        forM_ [2*i, 2*i + i..m] $ \j -> do
          writeArray sieve j False
    return sieve
 
primesToUO :: Int -> [Int]
primesToUO top | top > 1   = [i | (i,True) <- assocs $ sieveUO top]
               | otherwise = []

markOff :: (MArray a Bool m)  => a Int Bool -> Int -> Int -> m ()
markOff arr a n = do
  forM_ [2*a,2*a+a..n] $ \b -> writeArray arr b False

markOffST :: STUArray s Int Bool -> Int -> Int -> (ST s) ()
markOffST arr a n = do
  forM_ [2*a,2*a+a..n] $ \b -> writeArray arr b False
