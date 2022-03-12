module Main where

import Control.Exception (throw)
import Data.List
import System.IO

data BFToken = TokenOpen | TokenClose | TokenRight | TokenLeft | TokenInc | TokenDec | TokenOut | TokenIn deriving (Show)

data BFTree = NBlock [BFTree] | NRight | NLeft | NInc | NDec | NIn | NOut | NStatements [BFTree] deriving (Show)

newtype BFState = BFState (Int, [Int]) deriving (Show)

tokenStrings = [(TokenOpen, "["), (TokenClose, "]"), (TokenRight, ">"), (TokenLeft, "<"), (TokenInc, "+"), (TokenDec, "-"), (TokenOut, "."), (TokenIn, ",")]

singleToken s =
  case find (\(token, pat) -> pat `isPrefixOf` s) tokenStrings of
    Just (token, pat) -> Just (token, drop (length pat) s)
    Nothing -> Nothing

tokensWithIdx idx [] = []
tokensWithIdx idx s =
  case singleToken s of
    Just (token, rest) -> (token, idx, idx + sz) : tokensWithIdx (idx + sz) rest
      where
        sz = length s - length rest
    Nothing -> tokensWithIdx (succ idx) (drop 1 s)

tokensFromLines idx ls = concatMap (\(i, l) -> map (\(t, a, b) -> (t, (a, b, i))) (tokensWithIdx 0 l)) (zip [0 ..] ls)

nodeFromToken x = case x of
  TokenRight -> NRight
  TokenLeft -> NLeft
  TokenInc -> NInc
  TokenDec -> NDec
  TokenOut -> NOut
  TokenIn -> NIn
  _ -> error "Token not matched"

parseBlock acc [] = error "Didn't found matching close"
parseBlock (NBlock acc) (t : tks) =
  case t of
    TokenOpen -> parseBlock (NBlock (innerBlock : acc)) rest
      where
        (innerBlock, rest) = parseBlock (NBlock []) tks
    TokenClose -> (NBlock acc, tks)
    other -> parseBlock (NBlock (nodeFromToken t : acc)) tks
parseBlock wrong tks = error "Expected an NBlock"

parseProgram acc [] = acc
parseProgram acc (t : tks) =
  case t of
    TokenOpen -> parseProgram (block : acc) rest
      where
        (block, rest) = parseBlock (NBlock []) tks
    other -> parseProgram (nodeFromToken t : acc) tks

execute (BFState (pointer, mem)) ast =
  case ast of
    NRight -> BFState (succ pointer, mem)
    NLeft -> BFState (pred pointer, mem)
    NStatements list -> foldl execute (BFState (pointer, mem)) list
    NBlock list -> foldl execute (BFState (pointer, mem)) list
    _ -> BFState (pointer, mem)

main :: IO ()
main = do
  myData <- readFile "./samples/a.bf"
  print $ execute (BFState (0, replicate 100 0)) $ NStatements $ parseProgram [] $ map fst $ tokensFromLines 0 (lines myData)
