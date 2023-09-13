declare module '@env' {
  export const ENVIRONMENT: 'development' | 'staging' | 'production';
  export const SENTRY_DSN: string;
  export const SENTRY_ENABLE: 'true' | 'false';
  export const API_URL: string;
  export const CMS_URL: string;
  export const APP_NAME: string;
  export const AUTH0_CLIENT_ID: string;
  export const AUTH0_DOMAIN: string;
  export const AUTH0_URL: string;
  export const AUTH0_IOS_CALLBACK_URL: string;
  export const AUTH0_ANDROID_CALLBACK_URL: string;

  export const ZOOP_CUSTOMER_SERVICE_PHONE_NUMBER: string;

  export const AGORA_APP_ID: string;

  export const LIMIT_ARTICLE_SAME_TOPIC: string;

  export const DESIGN_SYSTEM_MODE: string;

  export const GOOGLE_ANALYTICS_TIME_SUBMIT: string;
  export const STREAM_CHAT_INSTANCE: string;
  export const CLOUDFLARE_SITE_KEY: string;
  export const GG_CAPTCHA_SITE_KEY: string;
}
