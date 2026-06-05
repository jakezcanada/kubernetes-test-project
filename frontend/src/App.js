import React, { useState } from 'react';
import './App.css';

function App() {
  const [count, setCount] = useState(0);

  const handleIncrement = () => setCount(c => c + 1);
  const handleReset = () => setCount(0);
  const handleCrash = () => { throw new Error('Intentional crash for demo'); };

  return (
    <div className="App" style={{ minHeight: '100vh', display: 'flex', justifyContent: 'center', alignItems: 'center', background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' }}>
      <div style={{ background: 'white', padding: 40, borderRadius: 12, boxShadow: '0 10px 30px rgba(0,0,0,0.2)', textAlign: 'center' }}>
        <h1 style={{ marginTop: 0, color: '#333', marginBottom: 30 }}>Button Controls</h1>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 15, minWidth: 400 }}>
          <button onClick={handleIncrement} style={{ padding: '12px 20px', fontSize: 16, fontWeight: 'bold', backgroundColor: '#667eea', color: 'white', border: 'none', borderRadius: 6, cursor: 'pointer', transition: 'background 0.3s' }}>
            Increment: {count}
          </button>
          <button onClick={handleReset} style={{ padding: '12px 20px', fontSize: 16, fontWeight: 'bold', backgroundColor: '#48bb78', color: 'white', border: 'none', borderRadius: 6, cursor: 'pointer', transition: 'background 0.3s' }}>
            Reset
          </button>
          <button onClick={handleCrash} style={{ padding: '12px 20px', fontSize: 16, fontWeight: 'bold', backgroundColor: '#c0392b', color: 'white', border: 'none', borderRadius: 6, cursor: 'pointer', transition: 'background 0.3s' }}>
            Crash app
          </button>
          <button style={{ padding: '12px 20px', fontSize: 16, fontWeight: 'bold', backgroundColor: '#f39c12', color: 'white', border: 'none', borderRadius: 6, cursor: 'pointer', transition: 'background 0.3s' }}>
            Dummy Button
          </button>
        </div>
      </div>
    </div>
  );
}

export default App;
