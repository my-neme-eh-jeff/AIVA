import { AudioRecorderWithVisualizer } from "@/Components/audio-record-visualiser";
import { Toaster } from "sonner";

export default function DashboardPage() {
  return (
    <div className="h-screen">
      <Toaster
        position="top-right"
        richColors
        pauseWhenPageIsHidden
        theme="dark"
      />
      <div className="fixed bottom-0 mb-2 w-full justify-center">
        <AudioRecorderWithVisualizer />
      </div>
    </div>
  );
}
