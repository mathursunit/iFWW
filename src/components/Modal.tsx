import React from "react";
import clsx from "clsx";

interface ModalProps {
  isOpen: boolean;
  onClose?: () => void;
  children: React.ReactNode;
  className?: string;
  hideCloseButton?: boolean;
}

const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  children,
  className,
  hideCloseButton,
}) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-40 flex items-center justify-center">
      <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" />
      <div
        className={clsx(
          "relative z-50 w-full max-w-md rounded-2xl bg-panel p-5 shadow-xl",
          className
        )}
      >
        {!hideCloseButton && onClose && (
          <button
            onClick={onClose}
            className="absolute right-3 top-3 rounded-full p-1 text-gray-400 hover:bg-gray-700 hover:text-gray-100"
          >
            ✕
          </button>
        )}
        {children}
      </div>
    </div>
  );
};

export default Modal;
