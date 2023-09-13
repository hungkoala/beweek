declare type Unpacked<T> = T extends (infer U)[] ? U : T;
declare type Required<T> = {
  [P in keyof T]-?: T[P];
};

declare type RequireKeys<T, K extends keyof T> = T & { [P in K]-?: T[P] };

declare type Modify<T, R> = Omit<T, keyof R> & R;
declare module 'react-native-keyboard-aware-scroll-view/lib/KeyboardAwareHOC' {
  // https://stackoverflow.com/questions/39040108/import-class-in-definition-file-d-ts
  // Import in here because d.ts files are treated as an ambient (global) module declarations only if they don't have any imports
  import React from 'react';
  import { KeyboardAwareScrollViewProps } from 'react-native-keyboard-aware-scroll-view';

  const listenToKeyboardEvents: (
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    Comp: any,
  ) => React.FC<KeyboardAwareScrollViewProps>;

  export default listenToKeyboardEvents;
}

declare module 'react-native-keep-awake';
declare module 'react-native-slider';
