
import           Language.Fixpoint.Solver        (solveFQ)
import           Language.Fixpoint.Horn.Solve    (solveHorn)
import qualified Language.Fixpoint.Misc         as Misc 
import qualified Language.Fixpoint.Types        as F 
import qualified Language.Fixpoint.Types.Config as F 
import qualified Language.Fixpoint.Utils.Files  as F 
import           System.Exit
import qualified Control.Exception              as Ex 

main :: IO ()
main = do
  cfg <- F.getOpts
  Misc.writeLoud $  "Options: " ++ show cfg
--   if isHorn cfg 
--    then ...
  e <- solveQuery cfg
  exitWith e

---------------------------------------------------------------------------
solveQuery :: F.Config -> IO ExitCode
solveQuery cfg     = solver cfg `Ex.catch` errorExit
  where 
    solver     
      | isHorn cfg = solveHorn 
      | otherwise  = solveFQ 

isHorn :: F.Config -> Bool 
isHorn = F.isExtFile F.Smt2 . F.srcFile

errorExit :: F.Error -> IO ExitCode
errorExit e = do
  Misc.colorStrLn Misc.Sad ("Oops, unexpected error: " ++ F.showpp e)
  return (ExitFailure 2)