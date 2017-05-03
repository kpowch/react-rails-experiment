import React from 'react';
import ReactDOM from 'react-dom';

export default class Sidebar extends React.Component {

  render() {
    // this makes the code more readable
    const { notifications } = this.props

    return (
      <div className='sidebar-notifications notification'>
        {notifications.map((n) =>
          <p key={n.id}>{n.content}</p>
        )}
      </div>
    )
  }
}
