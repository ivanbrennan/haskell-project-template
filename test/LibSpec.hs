module LibSpec (main, spec) where

import Test.Hspec
    ( Spec
    , hspec
    , describe
    , it
    , shouldBe
    , shouldNotBe
    )

import Lib

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
    helloWorldSpec
    goodbyeWorldSpec

helloWorldSpec :: Spec
helloWorldSpec = describe "helloWorld" $
    it "says hello" $
        helloWorld `shouldBe` "hello world!"

goodbyeWorldSpec :: Spec
goodbyeWorldSpec = describe "goodbyeWorld" $
    it "does not say goodbye" $
        helloWorld `shouldNotBe` "goodbye world!"
