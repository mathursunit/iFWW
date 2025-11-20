import React from "react";

interface HeaderProps {
  onStatsClick: () => void;
  onHintClick: () => void;
  hintUsed: boolean;
}

const Header: React.FC<HeaderProps> = ({
  onStatsClick,
  onHintClick,
  hintUsed,
}) => {
  return (
    <header className="panel flex items-center justify-between rounded-xl bg-panel px-4 py-3 shadow-md">
      <button
        onClick={onStatsClick}
        className="flex h-9 w-9 items-center justify-center rounded-full bg-gray-700/70 text-gray-200 hover:bg-gray-600 active:scale-95"
        aria-label="Statistics"
      >
        <svg width="18" height="18" viewBox="0 0 24 24" className="fill-current">
          <rect x="3" y="10" width="3" height="11" rx="1" />
          <rect x="10.5" y="6" width="3" height="15" rx="1" />
          <rect x="18" y="2" width="3" height="19" rx="1" />
        </svg>
      </button>

      <div className="flex flex-col items-center text-center">
        <div className="flex items-center gap-2">
          <span
            className="text-3xl font-bold"
            style={{ fontFamily: "'Fredoka One', cursive" }}
          >
            <span className="text-[#FBBF24]">Sun</span>
            <span className="text-[#60A5FA]">Sar</span>
          </span>
          <svg
            width="26"
            height="26"
            viewBox="0 0 24 24"
            className="text-[#FBBF24]"
          >
            <circle cx="12" cy="12" r="4" fill="currentColor" />
            <g
              stroke="currentColor"
              strokeWidth="1.6"
              strokeLinecap="round"
              fill="none"
            >
              <line x1="12" y1="2" x2="12" y2="5" />
              <line x1="12" y1="19" x2="12" y2="22" />
              <line x1="4.22" y1="4.22" x2="6.34" y2="6.34" />
              <line x1="17.66" y1="17.66" x2="19.78" y2="19.78" />
              <line x1="2" y1="12" x2="5" y2="12" />
              <line x1="19" y1="12" x2="22" y2="12" />
              <line x1="4.22" y1="19.78" x2="6.34" y2="17.66" />
              <line x1="17.66" y1="6.34" x2="19.78" y2="4.22" />
            </g>
          </svg>
        </div>
        <div className="mt-1 text-xs font-semibold uppercase tracking-[0.16em] text-gray-300">
          Fun with words
        </div>
      </div>

      <button
        onClick={onHintClick}
        disabled={hintUsed}
        className={`flex h-9 w-9 items-center justify-center rounded-full ${
          hintUsed
            ? "bg-gray-700/40 text-gray-500 cursor-not-allowed"
            : "bg-gray-700/70 text-yellow-300 hover:bg-gray-600 active:scale-95"
        }`}
        aria-label="Hint"
      >
        <svg width="18" height="18" viewBox="0 0 24 24" className="fill-current">
          <path d="M9 21h6v-1H9v1Zm3-19a6.5 6.5 0 0 0-3.79 11.83c.4.3.79.83.92 1.35l.19.75h5.36l.19-.75c.13-.52.52-1.05.92-1.35A6.5 6.5 0 0 0 12 2Zm0 2a4.5 4.5 0 0 1 2.62 8.16c-.87.65-1.46 1.58-1.69 2.6h-1.86c-.23-1.02-.82-1.95-1.69-2.6A4.5 4.5 0 0 1 12 4Z" />
        </svg>
      </button>
    </header>
  );
};

export default Header;
