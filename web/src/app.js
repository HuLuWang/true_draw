import { Component } from 'react'
import './app.scss'

class App extends Component {
  componentDidMount () {}
  // onShow
  componentDidShow () {}
  // onHide
  componentDidHide () {}
  // onError
  componentDidCatchError () {}

  // this.props.children 是将要会渲染的页面
  render () {
    return this.props.children
  }
}

export default App
