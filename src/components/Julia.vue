<template>
  <div class="container">
    <div class="instructions">
      <h1>Filled Julia set</h1>
      <p>Click on a position to view the iteration path.</p>
    </div>
    <canvas ref="canvas"></canvas>
  </div>
</template>

<script>
import GL from 'GL'
import shaderSource from '../assets/julia.glsl'
import pathVertexShader from '../assets/path.vs.glsl'
import pathFragmentShader from '../assets/path.fs.glsl'

export default {
  name: 'Julia',
  props: ['c'],
  data () {
    return {
      gl: null,
      scale: [3, 3],
      shader: null,
      pathShader: null
    }
  },
  mounted () {
    // Context
    this.gl = GL.create({
      canvas: this.$refs.canvas
    })

    // Shaders
    this.shader = new GL.Shader(GL.Shader.SCREEN_VERTEX_SHADER, shaderSource)
    this.pathShader = new GL.Shader(pathVertexShader, pathFragmentShader)

    // Mouse events
    this.gl.onmousedown = (e) => {
      const z = [
        Math.round((e.canvasx / this.gl.canvas.width - 0.5) * this.scale[0] * 1000) / 1000,
        -Math.round((1 - e.canvasy / this.gl.canvas.height - 0.5) * this.scale[1] * 1000) / 1000
      ]

      this.showPath(z)
    }

    this.gl.captureMouse()

    // Initialize
    this.gl.reset()
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
        u_c: this.c,
        u_scale: this.scale,
        u_offset: [0.5, 0.5]
      })
    },
    reset () {
      this.gl.canvas.width = this.gl.canvas.clientWidth
      this.gl.canvas.height = this.gl.canvas.clientHeight

      this.gl.makeCurrent()
      this.gl.reset()
      this.draw()
    },
    showPath (z0) {
      const z = [z0[0], z0[1]]
      const vertices = [z0[0], z0[1], 0]

      for (let i = 0; i < 100; ++i) {
        const x = z[0]
        const y = z[1]

        z[0] = x * x - y * y + this.c[0]
        z[1] = 2 * x * y + this.c[1]

        vertices.push(z[0])
        vertices.push(z[1])
        vertices.push(i * 2 + 1)

        vertices.push(z[0])
        vertices.push(z[1])
        vertices.push(i * 2 + 2)
      }

      this.draw()
      this.gl.reset()

      const mesh = GL.Mesh.load({ vertices })

      this.pathShader.uniforms({
        u_scale: this.scale,
        u_offset: [0.5, 0.5]
      }).draw(mesh, this.gl.LINES)
    }
  },
  watch: {
    c () {
      this.draw()
    }
  },
  destroyed () {
    this.gl.makeCurrent()
    this.gl.destroy()
  }
}
</script>

<style scoped>
</style>
