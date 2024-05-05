{-# OPTIONS --erased-matches #-}

module Greeting where

open import Haskell.Prelude

hello : String
hello = "Hello world!"
{-# COMPILE AGDA2HS hello #-}
