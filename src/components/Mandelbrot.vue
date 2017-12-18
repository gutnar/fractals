<template>
  <div class="container">
    <div class="instructions">
      <h1>Mandelbrot set</h1>
      <p>Click or hold down the mouse button to change <strong>c</strong>.</p>
      <p>
        c = <input type="number" step="0.01" v-model="value[0]"> + <input type="number" step="0.01" v-model="value[1]"> i
      </p>
    </div>
    <div class="c-marker" :style="{ left: (value[0]/scale[0]+offset[0])*gl.canvas.width+'px', top: (1-(value[1]/scale[1]+offset[1]))*gl.canvas.height+'px' }" v-if="gl"></div>
    <canvas ref="canvas"></canvas>
  </div>
</template>

<script>
import GL from 'GL'
import shaderSource from '../assets/mandelbrot.glsl'

export default {
  name: 'Mandelbrot',
  props: ['value'],
  data () {
    return {
      gl: null,
      scale: [3, 3],
      offset: [0.75, 0.5],
      shader: null,
      mousedown: false,
      mousepos: null,
      mousedownListener: () => {
        this.mousedown = true
      },
      mouseupListener: () => {
        this.mousedown = false
      }
    }
  },
  mounted () {
    // Context
    this.gl = GL.create({
      canvas: this.$refs.canvas
    })

    // Mouse events
    this.gl.onmousemove = (e) => {
      this.mousepos = [e.canvasx, e.canvasy]

      if (this.mousedown) {
        this.c = [
          Math.round((this.mousepos[0] / this.gl.canvas.width - this.offset[0]) * this.scale[0] * 1000) / 1000,
          -Math.round((1 - this.mousepos[1] / this.gl.canvas.height - this.offset[1]) * this.scale[1] * 1000) / 1000
        ]

        this.$emit('input', this.c)
      }
    }

    this.gl.onmousedown = (e) => {
      this.mousedownListener()
      this.gl.onmousemove(e)
    }

    this.gl.onmouseup = () => {
      this.mouseupListener()
    }

    this.gl.captureMouse()

    // Track whether mouse button is pressed or not
    window.addEventListener('mousedown', this.mousedownListener)
    window.addEventListener('mouseup', this.mouseupListener)

    // Shader
    this.shader = new GL.Shader(GL.Shader.SCREEN_VERTEX_SHADER, shaderSource)

    // Initialize
    this.reset()
  },
  methods: {
    draw () {
      this.scale = [3, 3]

      if (this.gl.canvas.width < this.gl.canvas.height) {
        this.scale[1] *= this.gl.canvas.height / this.gl.canvas.width
      } else {
        this.scale[0] *= this.gl.canvas.width / this.gl.canvas.height
      }

      this.gl.makeCurrent()
      this.shader.toViewport({
        u_scale: this.scale,
        u_offset: this.offset
      })
    },
    reset () {
      this.gl.canvas.width = this.gl.canvas.clientWidth
      this.gl.canvas.height = this.gl.canvas.clientHeight

      this.gl.makeCurrent()
      this.gl.reset()
      this.draw()
    }
  },
  destroyed () {
    this.gl.makeCurrent()
    this.gl.destroy()

    window.removeEventListener('mousedown', this.mousedownListener)
    window.removeEventListener('mouseup', this.mouseupListener)
  }
}
</script>

<style scoped>
.c-marker {
  position: absolute;
  width: 3px;
  height: 3px;
  border-radius: 1.5px;
  background: red;
}
</style>
