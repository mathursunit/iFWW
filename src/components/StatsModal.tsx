import React from "react";
import Modal from "./Modal";
import { StatsState } from "../types";

interface StatsModalProps {
  isOpen: boolean;
  onClose: () => void;
  stats: StatsState;
}

const StatCard: React.FC<{ label: string; value: number }> = ({
  label,
  value,
}) => (
  <div className="flex flex-col items-center justify-center rounded-lg bg-gray-800/60 px-3 py-2">
    <div className="text-2xl font-bold text-white">{value}</div>
    <div className="mt-1 text-xs uppercase tracking-wide text-gray-400">
      {label}
    </div>
  </div>
);

const StatsModal: React.FC<StatsModalProps> = ({ isOpen, onClose, stats }) => {
  return (
    <Modal isOpen={isOpen} onClose={onClose}>
      <h2 className="text-center text-xl font-bold text-white">Statistics</h2>
      <div className="mt-4 grid grid-cols-4 gap-2">
        <StatCard label="Played" value={stats.played} />
        <StatCard label="Won" value={stats.won} />
        <StatCard label="Streak" value={stats.streak} />
        <StatCard label="Max Streak" value={stats.maxStreak} />
      </div>
    </Modal>
  );
};

export default StatsModal;
