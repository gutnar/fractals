<template>
  <div id="app">
    <Mandelbrot v-model="c" ref="mandelbrot"/>
    <Julia :c="c" ref="julia"/>
  </div>
</template>

<script>
import Mandelbrot from './components/Mandelbrot'
import Julia from './components/Julia'

export default {
  name: 'app',
  components: {
    Mandelbrot,
    Julia
  },
  data () {
    return {
      c: [-0.63, 0.4],
      resizeListener: () => {
        this.resetSize()
      }
    }
  },
  mounted () {
    this.resetSize()
    window.addEventListener('resize', this.resizeListener)
  },
  methods: {
    resetSize () {
      const mandelbrotWidth = window.innerWidth / 2 // Math.min(window.innerWidth / 2, window.innerHeight * 1.5)

      this.$refs.mandelbrot.$refs.canvas.style.width = mandelbrotWidth + 'px'
      this.$refs.julia.$refs.canvas.style.width = window.innerWidth - mandelbrotWidth - 1 + 'px'

      setTimeout(() => {
        this.$refs.mandelbrot.reset()
        this.$refs.julia.reset()
      })
    }
  },
  destroyed () {
    window.removeEventListener('resize', this.resizeListener)
  }
}
</script>

<style>
body {
  margin: 0;
}

#app {
  display: flex;
}

canvas {
  display: block;
  margin: 0;
  height: 100vh;
}

.container + .container {
  border-left: 1px solid #ccc;
}

.container {
  position: relative;
}

.instructions {
  color: white;
  position: absolute;
  top: 0;
  left: 20px;
}
</style>
