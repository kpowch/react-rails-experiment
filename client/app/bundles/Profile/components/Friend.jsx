import React from 'react';
import ReactDOM from 'react-dom';

export default class Friend extends React.Component {

  render() {
    // this makes the code more readable
    const { friend, addSuggestedFriend, declineSuggestedFriend } = this.props;

    return (
      <div className='friend'>
        <div className='name-container'>
          <div className='card-name-container'>
            <img className='card-pic' src={friend.profile_picture}/>
              <div className='name-email'>
                <div className='card-name'>
                  {friend.first_name} {friend.last_name}<br/>
                </div>
                <div className='card-email'>
                {friend.email}<br/><br/>
                </div>
              </div>
          </div>
          <div className='card-bio'>
             {friend.bio}<br/>
          </div>
        </div>

        <div className='profile-column'>
          <div className="pie-wrapper progress-75 style-2">
            <span className="label">{friend.friendship_match * 100}<span className="smaller">%</span></span>
            <div className="pie">
            <div className="left-side half-circle"></div>
            <div className="right-side half-circle"></div>
          </div>
          <div className="shadow"></div>
        </div>
          <div className='friend-buttons'>
            <div className='add-friend'>
              <a className='form-button' onClick={addSuggestedFriend(friend)}>Add Friend</a><br/><br/>
            </div>
            <div className='skip-friend'>
              <a className='button' onClick={declineSuggestedFriend(friend)}>Skip >></a><br/>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
