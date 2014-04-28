import System.Environment (getArgs, getProgName)
import Control.Concurrent (forkIO)
import Network (Socket, PortID(PortNumber), withSocketsDo, 
                listenOn, accept)
import System.IO (hPutStr, hGetLine, hFlush)
import Control.Monad (forever)
import System.Process (readProcess)

-- Courtesy Alan Ribic

main = withSocketsDo $ do
  args <- getArgs
  prog <- getProgName
  case args of
    [port] -> do
      socket <- listenOn $ PortNumber (fromIntegral (read port :: Int))
      putStrLn $ "Listening for requests on " ++ port
      handleRequest socket
    _ ->
      putStrLn $ "usage: " ++ prog ++ " <port>"

handleRequest s = do
  (handle, _, _) <- accept s
  forkIO $ do input <- hGetLine handle
              let args = words input
              print $ "Doing AI for: " ++ (show args)
              response <- edaxGo args
              hPutStr handle response
              hFlush handle
  handleRequest s

-- /Courtesy Alan Ribic ish
scriptPath :: String
scriptPath = "/Users/michelle/edax/4.3.2/bin/go.exp"

edaxGo :: [String] -> IO String
edaxGo args= readProcess scriptPath args []
