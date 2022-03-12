{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_reclang (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/gbrls/Programming/PL-Compilers-Interpreters/reclang/.stack-work/install/x86_64-linux-tinfo6/eaf4925c382226f32bff83e4fee535b96f7522b1606596f8998c74546fe64ac7/8.10.7/bin"
libdir     = "/home/gbrls/Programming/PL-Compilers-Interpreters/reclang/.stack-work/install/x86_64-linux-tinfo6/eaf4925c382226f32bff83e4fee535b96f7522b1606596f8998c74546fe64ac7/8.10.7/lib/x86_64-linux-ghc-8.10.7/reclang-0.1.0.0-95jKqLjog31LTvx9gUeBd2-reclang"
dynlibdir  = "/home/gbrls/Programming/PL-Compilers-Interpreters/reclang/.stack-work/install/x86_64-linux-tinfo6/eaf4925c382226f32bff83e4fee535b96f7522b1606596f8998c74546fe64ac7/8.10.7/lib/x86_64-linux-ghc-8.10.7"
datadir    = "/home/gbrls/Programming/PL-Compilers-Interpreters/reclang/.stack-work/install/x86_64-linux-tinfo6/eaf4925c382226f32bff83e4fee535b96f7522b1606596f8998c74546fe64ac7/8.10.7/share/x86_64-linux-ghc-8.10.7/reclang-0.1.0.0"
libexecdir = "/home/gbrls/Programming/PL-Compilers-Interpreters/reclang/.stack-work/install/x86_64-linux-tinfo6/eaf4925c382226f32bff83e4fee535b96f7522b1606596f8998c74546fe64ac7/8.10.7/libexec/x86_64-linux-ghc-8.10.7/reclang-0.1.0.0"
sysconfdir = "/home/gbrls/Programming/PL-Compilers-Interpreters/reclang/.stack-work/install/x86_64-linux-tinfo6/eaf4925c382226f32bff83e4fee535b96f7522b1606596f8998c74546fe64ac7/8.10.7/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "reclang_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "reclang_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "reclang_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "reclang_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "reclang_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "reclang_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
