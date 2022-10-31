import { env } from 'process';

export const JWT_CONFIG = {
  secret: 'secret',
  expiresIn: '12h',
};

export const DB_OPTIONS = {
  database: env.PG_DATABASE,
  host: env.PG_HOST,
  port: parseInt(env.PG_PORT),
  user: env.PG_USERNAME,
  password: env.PG_PASSWORD,
};
