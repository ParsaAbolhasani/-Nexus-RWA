'use client';

import { WagmiProvider, createConfig, http } from 'wagmi';
import { mainnet, sepolia } from 'wagmi/chains';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { WalletConnect } from './components/WalletConnect';
import { TokenCard } from './components/TokenCard';
import { useState, useEffect } from 'react';

const config = createConfig({
  chains: [mainnet, sepolia],
  transports: {
    [mainnet.id]: http(),
    [sepolia.id]: http(),
  },
});

const queryClient = new QueryClient();

export default function Home() {
  const [tokens, setTokens] = useState([]);

  useEffect(() => {
    fetch('/api/tokens')
      .then(res => res.json())
      .then(data => setTokens(data))
      .catch(console.error);
  }, []);

  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <div className="min-h-screen p-8">
          <header className="flex justify-between items-center mb-8">
            <h1 className="text-3xl font-bold text-blue-400">🏛️ RWA-Nexus</h1>
            <WalletConnect />
          </header>

          <main>
            <section className="mb-8">
              <h2 className="text-xl font-semibold mb-4">🪙 Available RWA Tokens</h2>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                {tokens.map((token: any) => (
                  <TokenCard key={token.id} token={token} />
                ))}
              </div>
            </section>

            <section className="bg-gray-800/50 p-6 rounded-xl border border-gray-700">
              <h2 className="text-xl font-semibold mb-4">💎 Buy RWA Tokens</h2>
              <p className="text-gray-400">Connect your wallet to start investing in tokenized real-world assets.</p>
            </section>
          </main>
        </div>
      </QueryClientProvider>
    </WagmiProvider>
  );
}