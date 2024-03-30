import { AudioRecorderWithVisualizer } from "@/Components/audio-record-visualiser";

export default function DashboardPage() {
  return (
    <div className="h-screen place-items-center place-content-center">
      <div className="">
        <AudioRecorderWithVisualizer />
      </div>
    </div>
  );
}
