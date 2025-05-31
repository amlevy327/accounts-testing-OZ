// viem/predictAccountAddress.ts
import 'dotenv/config';
import { encodeFunctionData, getContract } from 'viem';
import { factoryAbi } from './abis';
import { publicClient } from './client';
import { factoryAddress } from './constants';

export async function predictAddress(salt: string, signer: `0x${string}`) {
  const initCallData = encodeFunctionData({
    abi: [
      {
        name: 'initializeECDSA',
        type: 'function',
        stateMutability: 'nonpayable',
        inputs: [{ name: 'signer', type: 'address' }],
        outputs: [],
      },
    ],
    functionName: 'initializeECDSA',
    args: [signer],
  });

  const factory = getContract({
    abi: factoryAbi,
    address: factoryAddress,
    client: publicClient,
  });

  const [predicted] = await factory.read.predictAddress([
    salt,
    initCallData,
  ]);

  return { predicted, initCallData };
}

// CLI entry point
if (require.main === module) {
  const salt = process.env.ACCOUNT_SALT; // 32-byte hex
  const signer = process.env.ACCOUNT_SIGNER as `0x${string}`; // Replace this

  predictAddress(salt, signer)
    .then(({ predicted }) => {
      console.log('Predicted account address:', predicted);
    })
    .catch((err) => {
      console.error('Error predicting address:', err);
    });
}
