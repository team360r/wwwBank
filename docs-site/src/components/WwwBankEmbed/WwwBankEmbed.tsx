import React, { useRef, useState, useEffect, useCallback } from 'react';
import styles from './WwwBankEmbed.module.css';

interface WwwBankEmbedProps {
  route?: string;
  height?: number;
  accessible?: boolean;
}

const APP_ORIGIN = 'http://localhost:8080';

export default function WwwBankEmbed({
  route = '/',
  height: initialHeight = 500,
  accessible,
}: WwwBankEmbedProps) {
  const iframeRef = useRef<HTMLIFrameElement>(null);
  const [height, setHeight] = useState(initialHeight);

  const sendMessage = useCallback(
    (type: string, payload: Record<string, unknown> = {}) => {
      iframeRef.current?.contentWindow?.postMessage(
        { source: 'wwwbank-tutorial', type, ...payload },
        APP_ORIGIN,
      );
    },
    [],
  );

  useEffect(() => {
    if (route) {
      sendMessage('navigate', { route });
    }
  }, [route, sendMessage]);

  useEffect(() => {
    if (accessible !== undefined) {
      sendMessage('setAccessible', { accessible });
    }
  }, [accessible, sendMessage]);

  const handleReload = () => {
    iframeRef.current?.contentWindow?.location.reload();
  };

  const handleToggleAccessible = () => {
    sendMessage('toggleAccessible');
  };

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <span>wwwBank Preview</span>
        <div className={styles.controls}>
          <button
            className={styles.controlButton}
            onClick={handleToggleAccessible}
            title="Toggle accessible mode"
          >
            Toggle A11y
          </button>
          <button
            className={styles.controlButton}
            onClick={handleReload}
            title="Reload app"
          >
            Reload
          </button>
        </div>
      </div>
      <iframe
        ref={iframeRef}
        className={styles.iframe}
        src={APP_ORIGIN}
        style={{ height }}
        title="wwwBank Flutter web app"
        allow="clipboard-write"
      />
      <div
        className={styles.resizeHandle}
        onMouseDown={(e) => {
          e.preventDefault();
          const startY = e.clientY;
          const startHeight = height;
          const onMove = (ev: MouseEvent) => {
            setHeight(Math.max(200, startHeight + ev.clientY - startY));
          };
          const onUp = () => {
            document.removeEventListener('mousemove', onMove);
            document.removeEventListener('mouseup', onUp);
          };
          document.addEventListener('mousemove', onMove);
          document.addEventListener('mouseup', onUp);
        }}
      >
        drag to resize
      </div>
    </div>
  );
}
