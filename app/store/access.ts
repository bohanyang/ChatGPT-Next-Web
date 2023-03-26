import { create } from "zustand";
import { persist } from "zustand/middleware";

export interface AccessControlStore {
  accessCode: string;

  updateCode: (_: string) => void;
  enabledAccessControl: () => boolean;
}

export const ACCESS_KEY = "access-control";

export const useAccessStore = create<AccessControlStore>()(
  persist(
    (set, get) => ({
      accessCode: "",
      enabledAccessControl() {
        return true;
      },
      updateCode(code: string) {
        set((state) => ({ accessCode: code }));
      },
    }),
    {
      name: ACCESS_KEY,
      version: 1,
    }
  )
);
