/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React from 'react';
import {
  SafeAreaView,
  Text,
  TouchableOpacity,
  View,
  Platform
} from 'react-native';
import RNInputMasking from 'react-native-input-masking'


class App extends React.Component {

  state = {
    value: ''
  }

  onChangeText = ({ nativeEvent }) => {
    this.setState({ value: nativeEvent.text })
  }

  blur = () => {
    if (this.inputMaskRef) {
      this.inputMaskRef.blur()
    }
  }

  focus = () => {
 
    if (this.inputMaskRef) {
    
      this.inputMaskRef.focus()
    }
  }

  _onError = ({nativeEvent}) => {

    console.log(nativeEvent.error)
    
  }



  render() {
    return (
      <SafeAreaView>
        <RNInputMasking
          style={{
            borderColor: 'black',
            borderWidth: 1,
            height: 50,
            alignSelf: 'center',
            marginTop: 5,
            width: 200
          }}
          ref={_ref => this.inputMaskRef = _ref}
          value={this.state.value}
          onChangeText={this.onChangeText}
          maskFormat="DDDD-DDDD-DDDD-DDDD"
          maskType={Platform.OS == "android" ? "credit-card" : ""}
          keyboardType="number-pad"
          placeholderTextColor="#cccccc"
          textColor="#000000"
          placeholder="4242-4242-4242-4242"
          onErrorForMasking={this._onError}
        />

        <View style={{justifyContent: 'center', alignItems: 'center', marginTop: 20}}>

          <TouchableOpacity onPress={this.focus} style={{padding: 10, backgroundColor: '#cccc', width: 100}}>
            <Text>
              Focus field
          </Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={this.blur}  style={{padding: 10, backgroundColor: '#3e3e', width: 100, marginTop: 10}}>
            <Text>
              Blur field
          </Text>
          </TouchableOpacity>

        </View>

      </SafeAreaView>
    )
  };
}

export default App;
