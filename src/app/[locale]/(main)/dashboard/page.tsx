"use client";
import { AudioRecorderWithVisualizer } from "@/Components/audio-record-visualiser";
import { useEffect, useState } from "react";
import { Toaster } from "sonner";

export default function DashboardPage() {
  const [audioFileResponse, setAudioFileResponse] = useState<string[]>([]);
  const [messageResponse, setMessageResponse] = useState<string[]>([]);
  useEffect(() => {
    console.log(messageResponse);
    console.log(audioFileResponse);
  }, [messageResponse, audioFileResponse]);

  const getAlignment = (index: number) =>
    index % 2 === 0 ? "items-end" : "items-start";

  return (
    <div className="h-screen">
      <Toaster
        position="top-right"
        richColors
        pauseWhenPageIsHidden
        theme="dark"
      />
      <div className="fixed bottom-0 mb-2 w-full justify-center">
        <AudioRecorderWithVisualizer
          messageResponse={messageResponse}
          audioFileResponse={audioFileResponse}
          setAudioFileResponse={setAudioFileResponse}
          setMessageResponse={setMessageResponse}
        />
      </div>
      <div className="flex flex-col gap-4 p-4">
        {messageResponse.map((message, index) => (
          <div className={`flex ${getAlignment(index)} w-full`}>
            <div className="max-w-half rounded-lg bg-gray-200 p-2">
              {message}
            </div>
          </div>
        ))}
        {audioFileResponse.map((audioUrl, index) => (
          <div className={`flex ${getAlignment(index + 1)} w-full`}>
            <audio key={index} src={audioUrl} controls className="mb-2"></audio>
          </div>
        ))}
      </div>
    </div>
  );
}
