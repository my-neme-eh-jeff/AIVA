"use client";
import { AudioRecorderWithVisualizer } from "@/Components/audio-record-visualiser";
import { useEffect, useState } from "react";
import { Toaster } from "sonner";
import { Avatar } from "@nextui-org/react";
import ReactPlayer from "react-player";
import { Search } from "lucide-react";
import { Button } from "@/Components/ui/button";

export default function DashboardPage() {
  const [audioFileResponse, setAudioFileResponse] = useState<string[]>([]);
  const [messageResponse, setMessageResponse] = useState<string[]>([]);
  const [youtubeResponse, setYoutubeResponse] = useState<string[]>([]);
  const [combinedResponses, setCombinedResponses] = useState<any>([]);
  const [trigger, setTrigger] = useState(0);

  useEffect(() => {
    const cr = messageResponse.map((message, index) => ({
      message,
      audioUrl: audioFileResponse[index] ? audioFileResponse[index] : "",
      isUser: index % 2 === 0,
    }));
    setCombinedResponses(cr);
  }, [messageResponse, audioFileResponse]);
  useEffect(() => {
    console.log(youtubeResponse)
  }, [youtubeResponse]);

  const getAlignmentClasses = (index: number) =>
    index % 2 === 0 ? "justify-end text-right" : "justify-start";

  const getMessageContainerClasses = (index: number) =>
    index % 2 === 0
      ? "items-end text-right ml-auto"
      : "items-start text-left mr-auto";

  // Adjust this value based on the actual height of your AudioRecorderWithVisualizer component
  const audioVisualizerHeight = "100px"; // Example height

  return (
    <div className="min-h-screen overflow-y-auto pb-[30px]">
      <Toaster
        position="top-right"
        richColors
        pauseWhenPageIsHidden
        theme="dark"
      />
      <div className="fixed bottom-0 z-10 w-full justify-center">
        <div
          className="m-4 rounded-none border-b-0 bg-gray-950 p-4 shadow-lg backdrop-blur-sm"
          style={{ height: audioVisualizerHeight }}
        >
          <AudioRecorderWithVisualizer
            setTrigger={setTrigger}
            trigger={trigger}
            messageResponse={messageResponse}
            audioFileResponse={audioFileResponse}
            setAudioFileResponse={setAudioFileResponse}
            setMessageResponse={setMessageResponse}
            youtubeResponse={youtubeResponse}
            setYoutubeResponse={setYoutubeResponse}
          />
        </div>
      </div>
      <div
        className="flex w-full flex-col gap-4 p-4"
        style={{ marginBottom: audioVisualizerHeight }}
      >
        {combinedResponses.length > 0 &&
          combinedResponses.map((response: any, index: number) => (
            <div
              key={index}
              className={`flex ${getAlignmentClasses(index)} w-full items-center gap-4`}
            >
              <div
                className={`flex max-w-lg flex-col ${getMessageContainerClasses(index)}`}
              >
                <Avatar
                  className="mb-3"
                  src={
                    response.isUser
                      ? "https://lh3.googleusercontent.com/a/ACg8ocKf4OFSZ0LEnFJqY4rzJ7N2TUIPGjxNZY1PpQ5K9XdJ=s432-c-no"
                      : undefined
                  }
                  name={!response.isUser ? "AIVA" : undefined}
                  size="md"
                />
                {response.audioUrl ? (
                  <ReactPlayer
                    url={response.audioUrl}
                    width="100%"
                    style={{ borderRadius: "6px" }}
                    height="50px"
                    controls
                    className="mb-2 !rounded-sm"
                  />
                ) : (
                  <ReactPlayer
                    url={response.youtubeUrl}
                    width="100%"
                    style={{ borderRadius: "6px" }}
                    height="50px"
                    controls
                    className="mb-2 !rounded-sm"
                  />
                )}
                <div className="rounded-lg bg-slate-800 p-2 text-white">
                  {response.message}
                </div>
                {index + 1 === combinedResponses.length && !response.isUser && (
                  <div>
                    <Button
                      className="text-[#17c964]"
                      onClick={() => {
                        setTrigger((prev) => prev + 1);
                      }}
                    >
                      <Search />
                    </Button>
                  </div>
                )}
              </div>
            </div>
          ))}
      </div>
    </div>
  );
}
