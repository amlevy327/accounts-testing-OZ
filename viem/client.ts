// viem/client.ts
import 'dotenv/config';
import { createPublicClient, http } from 'viem';
import { sepolia } from 'viem/chains';

const url = process.env.SEPOLIA_RPC_URL;
if (!url) {
  throw new Error("Missing SEPOLIA_RPC_URL in .env");
}

export const publicClient = createPublicClient({
  chain: sepolia,
  transport: http(url),
});