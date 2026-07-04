'use client';

interface TokenCardProps {
  token: {
    id: string;
    name: string;
    symbol: string;
    assetType: string;
    totalSupply: number;
    assetInfo?: { value: number; yieldRate: number };
  };
}

export function TokenCard({ token }: TokenCardProps) {
  return (
    <div className="bg-gray-800/70 p-4 rounded-xl border border-gray-700 hover:border-blue-500 transition">
      <h3 className="font-bold text-lg">{token.name}</h3>
      <p className="text-sm text-gray-400">{token.symbol}</p>
      <p className="text-sm text-gray-400 mt-2">Type: {token.assetType}</p>
      <p className="text-sm text-gray-400">Supply: {token.totalSupply}</p>
      {token.assetInfo && (
        <>
          <p className="text-sm text-green-400 mt-1">APY: {token.assetInfo.yieldRate}%</p>
          <p className="text-sm text-blue-400">TVL: ${token.assetInfo.value.toLocaleString()}</p>
        </>
      )}
      <button className="mt-4 w-full py-2 bg-blue-600 rounded-lg hover:bg-blue-700 transition">
        Invest
      </button>
    </div>
  );
}