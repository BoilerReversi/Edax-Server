import Network.Socket hiding (send, sendTo, recv, recvFrom)
import Network.Socket.ByteString (send, recv)
import qualified Data.ByteString.Char8 as B8

-- source: https://gist.github.com/1100407/77f43a49bb68bd7817f6fcae6b661275ac19c0d7

main = client "10.184.40.171" 5678
 
client' :: Int -> IO ()
client' = client "localhost"
 
client :: String -> Int -> IO ()
client host port = withSocketsDo $ do
                addrInfo <- getAddrInfo Nothing (Just host) (Just $ show port)
                let serverAddr = head addrInfo
                sock <- socket (addrFamily serverAddr) Stream defaultProtocol
                connect sock (addrAddress serverAddr)
                msgSender sock
                sClose sock
 
msgSender :: Socket -> IO ()
msgSender sock = do
  let msg = B8.pack "-------------------X-------XX------XO--------------------------- O\n"
  send sock msg
  rMsg <- recv sock 10
  B8.putStrLn rMsg

