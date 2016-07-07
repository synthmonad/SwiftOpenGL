//
//  OpenGLView.swift
//  SwiftOpenGL
//
//  Created by Pawel Ropa on 07/07/16.
//  Copyright © 2016 Pawel Ropa. All rights reserved.
//

import Foundation
import Cocoa
import OpenGL.GL3

class OpenGLView: NSOpenGLView {
	required init?(coder: NSCoder) {

		super.init(coder: coder)
		// We need to setup pixelFormat and context first by using NSOpenGLPixelFormat and NSOpenGLContext methods
		// pixel format will be instantiated using following attributes, however we could drop all the attributes and pass nil to the NSOpenGLPixelFormat, it wouldn't affect
		// what is being displayed at this point
		let attrs: [NSOpenGLPixelFormatAttribute] = [
			UInt32(NSOpenGLPFAAccelerated), // Use accelerated renderers, we could skip it for now
			UInt32(NSOpenGLPFAColorSize), UInt32(32), // Use 32-bit color
			UInt32(NSOpenGLPFAOpenGLProfile), // Use version's >= 3.2 core
			UInt32(NSOpenGLProfileVersion3_2Core),
			UInt32(0) // C API's expect to end with 0
		]

		guard let pixelFormat = NSOpenGLPixelFormat(attributes: attrs) else {
			// Invoking print directly adds a warning
			Swift.print("pixelFormat could not be constructed")
			return
		}
		self.pixelFormat = pixelFormat

		guard let context = NSOpenGLContext(format: pixelFormat, shareContext: nil) else {
			Swift.print("context could not be constructed")
			return
		}
		self.openGLContext = context
	}

	override func prepareOpenGL() {
		super.prepareOpenGL()

		// The buffer will clear each pixel to matrix green upon starting the creation of a new frame
		glClearColor(0.0, 1.0, 0.0, 1.0)

		// Run a test render
		drawView()
	}

	override func drawRect(dirtyRect: NSRect) {
		super.drawRect(dirtyRect)

		// Without this function the exampel would also work
		drawView()
	}

	private func drawView() {
		// We will clear color buffer with color which we have setup by invoking glClearColor function
		// GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT, GL_ACCUM_BUFFER_BIT, GL_STENCIL_BUFFER_BIT
		glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

		// We have finished rendering and now we need to send it to the screen
		glFlush()
	}
}
