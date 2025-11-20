import React from "react";
import { KEYBOARD_ROWS } from "../constants";
import { TileStatus } from "../types";
import clsx from "clsx";

interface KeyboardProps {
  onKey: (key: string) => void;
  letterStatuses: Record<string, TileStatus>;
}

const statusToKeyClass: Partial<Record<TileStatus, string>> = {
  correct: "bg-correct text-white",
  present: "bg-present text-white",
  absent: "bg-absent text-white",
};

const Keyboard: React.FC<KeyboardProps> = ({ onKey, letterStatuses }) => {
  const handleClick = (key: string) => () => onKey(key);

  return (
    <div className="mt-6 space-y-2">
      {KEYBOARD_ROWS.map((row, idx) => (
        <div key={idx} className="flex justify-center gap-1">
          {row.map((key) => {
            const isSpecial = key === "ENTER" || key === "BACKSPACE";
            const display =
              key === "BACKSPACE" ? <span className="text-sm">⌫</span> : key;
            const statusClass =
              statusToKeyClass[letterStatuses[key]] ?? "bg-keybg text-gray-200";

            return (
              <button
                key={key}
                onClick={handleClick(key)}
                className={clsx(
                  "flex items-center justify-center rounded-md text-sm font-semibold uppercase shadow",
                  statusClass,
                  isSpecial
                    ? "px-3 py-2 text-xs md:text-sm flex-[1.4]"
                    : "px-2 py-2 flex-1",
                  "hover:brightness-110 active:scale-95 transition"
                )}
              >
                {display}
              </button>
            );
          })}
        </div>
      ))}
    </div>
  );
};

export default Keyboard;
