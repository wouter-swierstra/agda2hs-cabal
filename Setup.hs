import Distribution.Simple
    ( UserHooks (..)
    , defaultMainWithHooks
    , simpleUserHooks
    )
import Distribution.Simple.PreProcess
    ( knownSuffixHandlers, PPSuffixHandler, PreProcessor (..),
      mkSimplePreProcessor, unsorted
    )
import Distribution.Types.BuildInfo(BuildInfo, hsSourceDirs)
import Distribution.Types.LocalBuildInfo(LocalBuildInfo)
import Distribution.Types.ComponentLocalBuildInfo(ComponentLocalBuildInfo)
import Distribution.Utils.Path (getSymbolicPath)
import System.Process (system)

import Data.List (intersperse)

agdaSuffixHandler :: PPSuffixHandler
agdaSuffixHandler = ("agda", preprocessAgda)

preprocessAgda :: BuildInfo -> LocalBuildInfo -> ComponentLocalBuildInfo -> PreProcessor
preprocessAgda bi _ _ =
    PreProcessor
        { platformIndependent = True
        , runPreProcessor = mkSimplePreProcessor $ \inFile outFile _verbosity ->
              let extraSrcDirs = map getSymbolicPath (hsSourceDirs bi) in
              let includes = case extraSrcDirs of
                    [] -> ""
                    paths -> "-i " ++ (concat $ intersperse " -i " extraSrcDirs)
              in let agda2hs = "agda2hs " ++ includes ++ " " ++ inFile in
              system agda2hs  >>
              return ()
        , ppOrdering = unsorted
        }

main :: IO ()
main =
    defaultMainWithHooks
        $ simpleUserHooks
            { hookedPreProcessors =
                knownSuffixHandlers <> [agdaSuffixHandler]
            }

