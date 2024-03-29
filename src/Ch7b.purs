module Ch7b where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Int (fromString)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, wrap)
import Data.Show.Generic (genericShow)
import Data.String (Pattern(..), split)
import Effect (Effect)
import Effect.Console (log)

newtype CSV = CSV String

derive instance newtypeCSV :: Newtype CSV _
derive newtype instance eqCSV :: Eq CSV
derive newtype instance showCSV :: Show CSV

class ToCSV a where
  toCSV :: a -> CSV

class FromCSV a where
  fromCSV :: CSV -> Maybe a

instance fromCSVPerson :: FromCSV Person where
  fromCSV (CSV str) = case split (Pattern ",") str of
    [ name, age, occupation ] -> case fromString age of
      Just age' -> case toOccupation occupation of
        Just occupation' -> Just $ Person
          { name: FullName name
          , age: Age age'
          , occupation: occupation'
          }
        Nothing -> Nothing
      Nothing -> Nothing
    _ -> Nothing

toOccupation :: String -> Maybe Occupation
toOccupation = case _ of
  "Doctor" -> Just Doctor
  "Dentist" -> Just Dentist
  "Lawyer" -> Just Lawyer
  "Unemployed" -> Just Unemployed
  _ -> Nothing

newtype FullName = FullName String

derive instance newtypeFullName :: Newtype FullName _
derive newtype instance eqFullName :: Eq FullName
instance showFullName :: Show FullName where
  show (FullName name) = name

newtype Age = Age Int

derive instance newTypeAge :: Newtype Age _
derive newtype instance showAge :: Show Age
derive newtype instance eqAge :: Eq Age

data Occupation = Doctor | Dentist | Lawyer | Unemployed

derive instance genericOccupation :: Generic Occupation _

instance showOccupation :: Show Occupation where
  show = genericShow

derive instance eqOccupation :: Eq Occupation

data Person = Person
  { name :: FullName
  , age :: Age
  , occupation :: Occupation
  }

derive instance eqPerson :: Eq Person

instance toCSVPerson :: ToCSV Person where
  toCSV (Person { name, age, occupation }) = CSV $ show name <> "," <> show age <> "," <> show occupation

test :: Effect Unit
test = do
  log $ show $ toCSV (Person { name: FullName "Sue Smith", age: Age 23, occupation: Doctor })
  log $ show $ toCSV (Person { name: FullName "Sue Smith", age: Age 23, occupation: Doctor }) == CSV "Sue Smith,23,Doctor"
  let
    person = Person
      { name: FullName "Sue Smith"
      , age: Age 23
      , occupation: Doctor
      }
  log $ show $ (toCSV person # fromCSV) == Just person
