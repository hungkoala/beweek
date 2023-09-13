import { ConferencePushData } from 'api/graphql.generated';

export type ConferenceCall = Pick<
  ConferencePushData,
  | 'confAlias'
  | 'confId'
  | 'confToken'
  | 'callerDisplayName'
  | 'callerAvatarUrl'
  | 'callerId'
  | 'calleeId'
  | 'confUrl'
  | 'expireTime'
>;
