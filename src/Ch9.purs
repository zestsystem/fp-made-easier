module Ch9 where

import Prelude (Unit, class Show, class Eq, ($), (==), (&&), discard, show)

import Effect (Effect)
import Effect.Console (log)

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

class Semigroup a where
  append :: a -> a -> a -- Combines 2 a's and produces an a. This meets the magma requirement of being cloesed under the binary operator <>.

infixr 5 append as <>

class Semigroup a <= Monoid a where
  mempty :: a

data AndBool = AFalse | ATrue

derive instance eqAndBool :: Eq AndBool
derive instance genericAndBool :: Generic AndBool _

instance showAndBool :: Show AndBool where
  show = genericShow

instance semigroupAndBool :: Semigroup AndBool where
  append ATrue ATrue = ATrue
  append _ AFalse = AFalse
  append AFalse _ = AFalse

instance monoidAndBool :: Monoid AndBool where
  mempty = ATrue

verifyAndBoolSemigroup :: Effect Unit
verifyAndBoolSemigroup = do
  log "verifying AndBool Semigroup Laws (1)"
  log $ show $ (AFalse <> ATrue) <> ATrue == AFalse <> (ATrue <> ATrue)

verifyAndBoolMonoid :: Effect Unit
verifyAndBoolMonoid = do
  log "verifying AndBool Monoid Laws (2)"
  log $ show $ mempty <> ATrue == ATrue <> mempty && ATrue <> mempty == ATrue
  log $ show $ mempty <> AFalse == AFalse <> mempty && AFalse <> mempty == AFalse

test :: Effect Unit
test = do
  log $ show $ ATrue <> ATrue
  log $ show $ ATrue <> AFalse
  log $ show $ AFalse <> AFalse
  log $ show $ mempty <> ATrue == ATrue
  log $ show $ mempty <> AFalse == ATrue
  verifyAndBoolSemigroup
  verifyAndBoolMonoid
