import React, { useEffect, useState } from "react";
import Modal from "./Modal";

interface EndGameModalProps {
  isOpen: boolean;
  isWin: boolean;
  solution: string;
  secondsToNext: number;
  onShare: () => void;
}

const formatSeconds = (total: number): string => {
  const h = Math.floor(total / 3600);
  const m = Math.floor((total % 3600) / 60);
  const s = total % 60;
  const hh = String(h).padStart(2, "0");
  const mm = String(m).padStart(2, "0");
  const ss = String(s).padStart(2, "0");
  return `${hh}:${mm}:${ss}`;
};

const EndGameModal: React.FC<EndGameModalProps> = ({
  isOpen,
  isWin,
  solution,
  secondsToNext,
  onShare,
}) => {
  const [remaining, setRemaining] = useState(secondsToNext);

  useEffect(() => {
    setRemaining(secondsToNext);
  }, [secondsToNext, isOpen]);

  useEffect(() => {
    if (!isOpen) return;
    if (remaining <= 0) return;
    const id = setInterval(() => {
      setRemaining((prev) => (prev > 0 ? prev - 1 : 0));
    }, 1000);
    return () => clearInterval(id);
  }, [isOpen, remaining]);

  const title = isWin ? "Congratulations!" : "Nice Try!";
  const subtitle = isWin
    ? "You guessed the word correctly."
    : "Better luck next time!";

  return (
    <Modal isOpen={isOpen} hideCloseButton>
      <div className="flex flex-col items-center text-center">
        <div className="text-lg font-bold tracking-wide text-[#C4B5FD]">
          {title}
        </div>
        <div className="mt-1 text-sm text-gray-200">{subtitle}</div>

        {!isWin && (
          <div className="mt-2 text-sm text-gray-300">
            The word was:{" "}
            <span className="font-semibold text-white">{solution}</span>
          </div>
        )}

        <div className="mt-4 h-px w-full bg-gray-700/80" />

        <div className="mt-4 flex w-full items-center justify-between gap-4">
          <div className="flex flex-col items-start">
            <div className="text-xs font-semibold tracking-[0.2em] text-gray-400">
              NEXT WORD IN
            </div>
            <div className="mt-1 text-2xl font-extrabold text-white">
              {formatSeconds(remaining)}
            </div>
          </div>

          <button
            onClick={onShare}
            className="mt-0 flex-1 rounded-xl bg-correct px-4 py-2 text-sm font-semibold text-white shadow hover:brightness-110 active:scale-95"
          >
            Share Results
          </button>
        </div>
      </div>
    </Modal>
  );
};

export default EndGameModal;
