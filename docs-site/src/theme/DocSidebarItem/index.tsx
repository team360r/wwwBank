import React from 'react';
import DocSidebarItem from '@theme-original/DocSidebarItem';
import type DocSidebarItemType from '@theme/DocSidebarItem';
import type { WrapperProps } from '@docusaurus/types';
import { useProgress } from '../../hooks/useProgress';

type Props = WrapperProps<typeof DocSidebarItemType>;

export default function DocSidebarItemWrapper(props: Props): React.JSX.Element {
  const { progress } = useProgress();
  const item = props.item;

  if (item.type === 'link' && progress.visitedPages.includes(item.href)) {
    return (
      <DocSidebarItem
        {...props}
        item={{
          ...item,
          label: `${item.label} ✓`,
          className: `${item.className ?? ''} sidebar-item--visited`.trim(),
        }}
      />
    );
  }

  return <DocSidebarItem {...props} />;
}
