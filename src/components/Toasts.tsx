import React from "react";
import { ToastMessage } from "../types";

interface ToastsProps {
  toasts: ToastMessage[];
}

const Toasts: React.FC<ToastsProps> = ({ toasts }) => {
  return (
    <div className="pointer-events-none fixed inset-x-0 top-3 z-50 flex justify-center">
      <div className="flex flex-col gap-2">
        {toasts.map((t) => (
          <div
            key={t.id}
            className="pointer-events-auto animate-toast-slide rounded-full bg-gray-900/90 px-4 py-2 text-sm font-semibold text-white shadow-lg"
          >
            {t.text}
          </div>
        ))}
      </div>
    </div>
  );
};

export default Toasts;
