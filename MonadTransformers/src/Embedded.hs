module Embedded where

import Control.Monad.Trans.Except
import Control.Monad.Trans.Maybe
import Control.Monad.Trans.Reader

-- We only need to use return once
-- because it's one big Monad
embedded :: MaybeT
            (ExceptT String
                     (ReaderT () IO))
            Int
embedded = return 1

-- We can sort of peel away the layers one by one:
maybeUnwrap :: ExceptT String
               (ReaderT () IO) (Maybe Int)
maybeUnwrap = runMaybeT embedded

-- Next
eitherUnwrap :: ReaderT () IO
                (Either String (Maybe Int))
eitherUnwrap = runExceptT maybeUnwrap

-- Lastly
readerUnwrap :: ()
             -> IO (Either String
                           (Maybe Int))
readerUnwrap = runReaderT eitherUnwrap


-- Exercise: Wrap It Up
-- Turn readerUnwrap from the previous example back into embedded
-- through the use of the data constructors for each transformer.

-- Modify it to make it work.
embedded' :: MaybeT
            (ExceptT String
                     (ReaderT () IO))
            Int
embedded' = MaybeT . ExceptT . ReaderT $ pure . (const (Right (Just 1)))
