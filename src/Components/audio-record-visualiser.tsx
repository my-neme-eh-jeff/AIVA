"use client";
import React, { useEffect, useMemo, useRef, useState } from "react";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/Components/ui/tooltip";
import { Button } from "@/Components/ui/button";
import { Download, Mic, Pause, Play, Send, Trash } from "lucide-react";
import { useTheme } from "next-themes";
import { cn } from "@/utils/ui";
import { motion, type Variants } from "framer-motion";
import { toast } from "sonner";
import axios from "axios";
import { siteConfig } from "siteConfig";

type Props = {
  className?: string;
  timerClassName?: string;
};
type Record = {
  id: number;
  name: string;
  file: any;
};
let recorder: MediaRecorder;
let recordingChunks: BlobPart[] = [];
let timerTimeout: NodeJS.Timeout;

const padWithLeadingZeros = (num: number, length: number): string => {
  return String(num).padStart(length, "0");
};
const downloadBlob = (blob: Blob) => {
  const downloadLink = document.createElement("a");
  downloadLink.href = URL.createObjectURL(blob);
  downloadLink.download = `Audio_${new Date().getMilliseconds()}.mp3`;
  document.body.appendChild(downloadLink);
  downloadLink.click();
  document.body.removeChild(downloadLink);
};
export const AudioRecorderWithVisualizer = ({
  className,
  timerClassName,
}: Props) => {
  const { theme } = useTheme();
  const [isRecording, setIsRecording] = useState<boolean>(false);
  const [isRecordingFinished, setIsRecordingFinished] =
    useState<boolean>(false);
  const [isPaused, setIsPaused] = useState(false); // Add this line to manage pause state
  const [timer, setTimer] = useState<number>(0);
  const [currentRecord, setCurrentRecord] = useState<Record>({
    id: -1,
    name: "",
    file: null,
  });
  const [
    loadingForSubmmittingAudioFileToFlaskServer,
    setLoadingForSubmmittingAudioFileToFlaskServer,
  ] = useState(false);

  const hours = Math.floor(timer / 3600);
  const minutes = Math.floor((timer % 3600) / 60);
  const seconds = timer % 60;
  const [hourLeft, hourRight] = useMemo(
    () => padWithLeadingZeros(hours, 2).split(""),
    [hours],
  );
  const [minuteLeft, minuteRight] = useMemo(
    () => padWithLeadingZeros(minutes, 2).split(""),
    [minutes],
  );
  const [secondLeft, secondRight] = useMemo(
    () => padWithLeadingZeros(seconds, 2).split(""),
    [seconds],
  );
  const mediaRecorderRef = useRef<{
    stream: MediaStream | null;
    analyser: AnalyserNode | null;
    mediaRecorder: MediaRecorder | null;
    audioContext: AudioContext | null;
  }>({
    stream: null,
    analyser: null,
    mediaRecorder: null,
    audioContext: null,
  });
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const animationRef = useRef<any>(null);

  function startRecording() {
    if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
      navigator.mediaDevices
        .getUserMedia({
          audio: true,
        })
        .then((stream) => {
          setIsRecording(true);
          // ============ Analyzing ============
          const AudioContext = window.AudioContext;
          const audioCtx = new AudioContext();
          const analyser = audioCtx.createAnalyser();
          const source = audioCtx.createMediaStreamSource(stream);
          source.connect(analyser);
          mediaRecorderRef.current = {
            stream,
            analyser,
            mediaRecorder: null,
            audioContext: audioCtx,
          };

          const mimeType = MediaRecorder.isTypeSupported("audio/mpeg")
            ? "audio/mpeg"
            : MediaRecorder.isTypeSupported("audio/webm")
              ? "audio/webm"
              : "audio/wav";

          const options = { mimeType };
          mediaRecorderRef.current.mediaRecorder = new MediaRecorder(
            stream,
            options,
          );
          mediaRecorderRef.current.mediaRecorder.start();
          recordingChunks = [];
          // ============ Recording ============
          recorder = new MediaRecorder(stream);
          recorder.start();
          recorder.ondataavailable = (e) => {
            recordingChunks.push(e.data);
          };
        })
        .catch((error) => {
          toast.error("Oops! There was an unexpected error.");
          console.log(error);
        });
    }
  }
  async function stopRecording(submit: boolean) {
    recorder.onstop = async () => {
      const recordBlob = new Blob(recordingChunks, {
        type: "audio/wav",
      });
      if (submit) {
        submitRecording(recordBlob);
      } else {
        downloadBlob(recordBlob);
      }
      setCurrentRecord({
        ...currentRecord,
        file: window.URL.createObjectURL(recordBlob),
      });
      recordingChunks = [];
    };
    recorder.stop();
    setIsRecording(false);
    setIsRecordingFinished(true);
    setTimer(0);
    clearTimeout(timerTimeout);
  }
  function resetRecording() {
    const { mediaRecorder, stream, analyser, audioContext } =
      mediaRecorderRef.current;
    if (mediaRecorder) {
      mediaRecorder.onstop = () => {
        recordingChunks = [];
      };
      mediaRecorder.stop();
    } else {
      toast.error("Could not reset recording please try again", {
        action: (
          <Button type="reset" onClick={() => resetRecording()}>
            Retry
          </Button>
        ),
      });
    }
    if (analyser) {
      analyser.disconnect();
    }
    if (stream) {
      stream.getTracks().forEach((track) => track.stop());
    }
    if (audioContext) {
      audioContext.close();
    }
    setIsRecording(false);
    setIsRecordingFinished(true);
    setTimer(0);
    clearTimeout(timerTimeout);
    cancelAnimationFrame(animationRef.current || 0);
    const canvas = canvasRef.current;
    if (canvas) {
      const canvasCtx = canvas.getContext("2d");
      if (canvasCtx) {
        const WIDTH = canvas.width;
        const HEIGHT = canvas.height;
        canvasCtx.clearRect(0, 0, WIDTH, HEIGHT);
      }
    }
  }
  const submitRecording = async (blob: Blob) => {
    const loadingToast = toast.loading("Loading");
    try {
      const formData = new FormData();
      formData.append("audio", blob, "audio.wav");
      const { data } = await axios.post(
        siteConfig.flaskBackendBaseUrl + "/transcription/",
        formData,
        {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        },
      );
      console.log(data);
      toast.success(`Language detected "${data.src_lang}"`);
    } catch (err) {
      toast.error("Oops an unexpected error occurred", {
        action: (
          <Button type="reset" onClick={() => submitRecording(blob)}>
            Retry
          </Button>
        ),
      });
      console.log(err);
    } finally {
      toast.dismiss(loadingToast);
    }
  };
  const play = () => {
    if (mediaRecorderRef.current.mediaRecorder && isRecording && isPaused) {
      recorder.resume();
      setIsPaused(false);
    }
  };
  const pause = () => {
    if (mediaRecorderRef.current.mediaRecorder && isRecording && !isPaused) {
      recorder.pause();
      setIsPaused(true);
    }
  };

  useEffect(() => {
    if (isRecording && !isPaused) {
      timerTimeout = setTimeout(() => {
        setTimer(timer + 1);
      }, 1000);
    }
    return () => clearTimeout(timerTimeout);
  }, [isRecording, timer, isPaused]);

  useEffect(() => {
    if (!canvasRef.current) return;
    const canvas = canvasRef.current;
    const canvasCtx = canvas.getContext("2d");
    const scale = window.devicePixelRatio; // Get the device pixel ratio, falling back to 1.
    const width = canvas.clientWidth * scale;
    const WIDTH = width;
    const height = canvas.clientHeight * scale;
    const HEIGHT = height;
    canvas.width = width;
    canvas.height = height;
    canvasCtx?.scale(scale, scale); // Normalize the coordinate system to use css pixels.
    const drawWaveform = (dataArray: Uint8Array) => {
      if (!canvasCtx) return;
      canvasCtx.clearRect(0, 0, WIDTH, HEIGHT);
      canvasCtx.fillStyle = "#D3FD50";
      const barWidth = 2;
      const spacing = 0.5;
      const maxBarHeight = HEIGHT / 2.5;
      const numBars = Math.floor(WIDTH / (barWidth + spacing));

      for (let i = 0; i < numBars; i++) {
        const barHeight = Math.pow(dataArray[i]! / 128.0, 8) * maxBarHeight;
        const x = (barWidth + spacing) * i;
        const y = HEIGHT / 2 - barHeight / 2;
        canvasCtx.fillRect(x, y, barWidth, barHeight);
      }
    };
    const visualizeVolume = () => {
      if (
        !mediaRecorderRef.current?.stream?.getAudioTracks()[0]?.getSettings()
          .sampleRate
      )
        return;
      if (!isRecording || isPaused) {
        cancelAnimationFrame(animationRef.current);
        return;
      }

      const bufferLength =
        (mediaRecorderRef.current?.stream?.getAudioTracks()[0]?.getSettings()
          .sampleRate as number) / 100;
      const dataArray = new Uint8Array(bufferLength);
      const draw = () => {
        if (!isRecording) {
          cancelAnimationFrame(animationRef.current || 0);
          return;
        }
        animationRef.current = requestAnimationFrame(draw);
        mediaRecorderRef.current?.analyser?.getByteTimeDomainData(dataArray);
        drawWaveform(dataArray);
      };

      draw();
    };

    if (isRecording) {
      visualizeVolume();
    } else {
      if (canvasCtx) {
        canvasCtx.clearRect(0, 0, WIDTH, HEIGHT);
      }
      cancelAnimationFrame(animationRef.current || 0);
    }

    return () => {
      cancelAnimationFrame(animationRef.current || 0);
    };
  }, [isRecording, theme, isPaused]);

  const canvasVariants: Variants = {
    hidden: { scale: 0, opacity: 0 },
    show: {
      scale: 1,
      opacity: 1,
      transition: {
        type: "spring",
        stiffness: 80,
        damping: 10,
      },
    },
    exit: { scale: 0, opacity: 0 },
  };
  const tooltipVariants: Variants = {
    hidden: { opacity: 0 },
    show: {
      opacity: 1,
      transition: {
        duration: 0.5,
      },
    },
    exit: { opacity: 0 },
  };
  const buttonVariants: Variants = {
    hidden: { opacity: 0 },
    show: {
      opacity: 1,
      transition: {
        duration: 0.5,
      },
    },
  };
  return (
    <div
      className={cn(
        "mx-auto flex h-16 w-full max-w-5xl place-items-center gap-2 rounded-md transition-all duration-1000",
        className,
      )}
    >
      <Timer
        isPaused={isPaused}
        pause={pause}
        play={play}
        hourLeft={hourLeft as unknown as string}
        hourRight={hourRight as unknown as string}
        minuteLeft={minuteLeft as unknown as string}
        minuteRight={minuteRight as unknown as string}
        secondLeft={secondLeft as unknown as string}
        secondRight={secondRight as unknown as string}
        timerClassName={timerClassName as unknown as string}
        isRecording={isRecording as unknown as boolean}
      />
      <motion.canvas
        initial="hidden"
        animate={isRecording ? "show" : "hidden"}
        exit="exit"
        variants={canvasVariants}
        className={`h-full w-full place-content-center place-items-center overflow-visible rounded-md border bg-background px-2 pb-3`}
        ref={canvasRef}
      />
      <div className="flex gap-2">
        <motion.div
          variants={tooltipVariants}
          initial="hidden"
          animate={isRecording ? "show" : "hidden"}
          exit="exit"
        >
          <TooltipProvider>
            <Tooltip>
              <TooltipTrigger asChild>
                <Button
                  onClick={resetRecording}
                  size={"icon"}
                  variant={"destructive"}
                >
                  <Trash size={15} color="red" />
                </Button>
              </TooltipTrigger>
              <TooltipContent className="m-2">
                <span> Reset recording</span>
              </TooltipContent>
            </Tooltip>
          </TooltipProvider>
        </motion.div>

        <TooltipProvider>
          <Tooltip>
            <TooltipTrigger asChild>
              <Button
                isLoading={loadingForSubmmittingAudioFileToFlaskServer}
                onClick={() =>
                  !isRecording ? startRecording() : stopRecording(false)
                }
                color="primary"
                size={"default"}
              >
                {!isRecording ? (
                  <motion.div
                    initial="hidden"
                    animate="show"
                    exit="hidden"
                    variants={buttonVariants}
                  >
                    <Mic size={15} />
                  </motion.div>
                ) : (
                  <motion.div
                    initial="hidden"
                    animate="show"
                    exit="hidden"
                    variants={buttonVariants}
                  >
                    <Download size={15} />
                  </motion.div>
                )}
              </Button>
            </TooltipTrigger>
            <TooltipContent className="m-2">
              <span>
                {!isRecording ? "Start recording" : "Download recording"}
              </span>
            </TooltipContent>
          </Tooltip>
        </TooltipProvider>

        <motion.div
          variants={tooltipVariants}
          initial="hidden"
          animate={isRecording ? "show" : "hidden"}
          exit="exit"
        >
          <TooltipProvider>
            <Tooltip>
              <TooltipTrigger asChild>
                <Button
                  onClick={() => stopRecording(true)}
                  size={"icon"}
                  variant={"default"}
                  color="#17c964"
                >
                  <Send size={15} />
                </Button>
              </TooltipTrigger>
              <TooltipContent className="m-2">
                <span>Send</span>
              </TooltipContent>
            </Tooltip>
          </TooltipProvider>
        </motion.div>
      </div>
    </div>
  );
};

const Timer = React.memo(
  ({
    isPaused,
    hourLeft,
    hourRight,
    minuteLeft,
    minuteRight,
    secondLeft,
    secondRight,
    timerClassName,
    isRecording,
    pause,
    play,
  }: {
    hourLeft: string;
    hourRight: string;
    minuteLeft: string;
    minuteRight: string;
    secondLeft: string;
    secondRight: string;
    timerClassName?: string;
    isRecording: boolean;
    pause: () => void;
    play: () => void;
    isPaused: boolean;
  }) => {
    const timerVariants: Variants = {
      show: {
        opacity: 1,
        transition: {
          ease: "easeIn",
        },
      },
      hide: {
        opacity: 0,
      },
      exit: { scale: 0, opacity: 0 },
    };

    return (
      <>
        <motion.div
          variants={timerVariants}
          animate={isRecording ? "show" : "hide"}
          exit="exit"
          initial="hide"
          className={cn(
            "absolute -top-12 mx-auto flex items-center justify-center gap-0.5 rounded-md border p-1.5 font-mono font-medium text-foreground",
            timerClassName,
          )}
        >
          <span className="rounded-md bg-background p-0.5 text-foreground">
            {hourLeft}
          </span>
          <span className="rounded-md bg-background p-0.5 text-foreground">
            {hourRight}
          </span>
          <span>:</span>
          <span className="rounded-md bg-background p-0.5 text-foreground">
            {minuteLeft}
          </span>
          <span className="rounded-md bg-background p-0.5 text-foreground">
            {minuteRight}
          </span>
          <span>:</span>
          <span className="rounded-md bg-background p-0.5 text-foreground">
            {secondLeft}
          </span>
          <span className="rounded-md bg-background p-0.5 text-foreground ">
            {secondRight}
          </span>
        </motion.div>
        <motion.div
          variants={timerVariants}
          animate={isRecording ? "show" : "hide"}
          exit="exit"
          initial="hide"
          className="flex gap-2"
        >
          {isPaused ? (
            <TooltipProvider>
              <Tooltip>
                <TooltipTrigger asChild>
                  <Button
                    onClick={() => play()}
                    size={"lg"}
                    variant={"outline"}
                  >
                    <Play size={15} />
                  </Button>
                </TooltipTrigger>
                <TooltipContent className="m-2">
                  <span>Click to Play</span>
                </TooltipContent>
              </Tooltip>
            </TooltipProvider>
          ) : (
            <TooltipProvider>
              <Tooltip>
                <TooltipTrigger asChild>
                  <Button
                    onClick={() => pause()}
                    size={"lg"}
                    variant={"outline"}
                  >
                    <Pause size={15} />
                  </Button>
                </TooltipTrigger>
                <TooltipContent className="m-2">
                  <span>Click to Pause</span>
                </TooltipContent>
              </Tooltip>
            </TooltipProvider>
          )}
        </motion.div>
      </>
    );
  },
);
Timer.displayName = "Timer";
