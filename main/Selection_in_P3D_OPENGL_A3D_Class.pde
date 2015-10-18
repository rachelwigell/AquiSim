public class Selection_in_P3D_OPENGL_A3D {

  // True if near and far points calculated.
  public boolean isValid() { return m_bValid; }
  private boolean m_bValid = false;

  // Maintain own projection matrix.
  public PMatrix3D getMatrix() { return m_pMatrix; }
  private PMatrix3D m_pMatrix = new PMatrix3D();

  // Maintain own viewport data.
  public int[] getViewport() { return m_aiViewport; }
  private int[] m_aiViewport = new int[4];

  // Store the near and far ray positions.
  public PVector ptStartPos = new PVector();
  public PVector ptEndPos = new PVector();

  // -------------------------

  public void captureViewMatrix(int fieldX, int fieldY)
  { // Call this to capture the selection matrix after 
    // you have called perspective() or ortho() and applied your
    // pan, zoom and camera angles - but before you start drawing
    // or playing with the matrices any further.

      // Capture current projection matrix.
      var projection = new PMatrix3D();
      var cameraFOV = 60 * (PI / 180);
      var cameraX = fieldX / 2;
      var cameraY = fieldY / 2;
      var cameraZ = cameraY / tan(cameraFOV / 2);
      var cameraNear = cameraZ / 10;
      var cameraFar = cameraZ * 10;
      var cameraAspect = fieldX / fieldY; 
      var top = cameraNear * tan(cameraFOV / 2);
      var bottom = -top;
      var left = bottom * cameraAspect;
      var right = top * cameraAspect;
      var near = cameraNear;
      var far = cameraFar;
      projection.set((2 * near) / (right - left), 0, (right + left) / (right - left),
                     0, 0, (2 * near) / (top - bottom), (top + bottom) / (top - bottom),
                     0, 0, 0, -(far + near) / (far - near), -(2 * far * near) / (far - near),
                     0, 0, -1, 0);
      m_pMatrix.set(projection);
      
      var modelView = new PMatrix3D();   
      var eyeX = cameraX;
      var eyeY = cameraY;
      var eyeZ = cameraZ;
      var centerX = cameraX;
      var centerY = cameraY;
      var centerZ = 0;
      var upX = 0;
      var upY = 1;
      var upZ = 0;
      
      var z = new PVector(eyeX - centerX, eyeY - centerY, eyeZ - centerZ);
      var y = new PVector(upX, upY, upZ);
      z.normalize();
      var x = PVector.cross(y, z);
      y = PVector.cross(z, x);
      x.normalize();
      y.normalize();
      
      var xX = x.x,
          xY = x.y,
          xZ = x.z;
      var yX = y.x,
          yY = y.y,
          yZ = y.z;
      var zX = z.x,
          zY = z.y,
          zZ = z.z;
      var cam = new PMatrix3D();
      cam.set(xX, xY, xZ, 0, yX, yY, yZ, 0, zX, zY, zZ, 0, 0, 0, 0, 1);
      cam.translate(-eyeX, -eyeY, -eyeZ);
      modelView.set(cam);;

      // Multiply by current modelview matrix.
      m_pMatrix.apply(modelView);

      // Invert the resultant matrix.
      m_pMatrix.invert();

      // Store the viewport.
      m_aiViewport[0] = 0;
      m_aiViewport[1] = 0;
      m_aiViewport[2] = fieldX;
      m_aiViewport[3] = fieldY;
    }


  // -------------------------

  public boolean gluUnProject(float winx, float winy, float winz, PVector result)
  {

    float[] in_ = new float[4];
    float[] out = new float[4];

    // Transform to normalized screen coordinates (-1 to 1).
    in_[0] = ((winx - (float)m_aiViewport[0]) / (float)m_aiViewport[2]) * 2.0f - 1.0f;
    in_[1] = ((winy - (float)m_aiViewport[1]) / (float)m_aiViewport[3]) * 2.0f - 1.0f;
    in_[2] = constrain(winz, 0f, 1f) * 2.0f - 1.0f;
    in_[3] = 1.0f;

    // Calculate homogeneous coordinates.
    out[0] = m_pMatrix.elements[0] * in_[0]
        + m_pMatrix.elements[1] * in_[1]
            + m_pMatrix.elements[2] * in_[2]
                + m_pMatrix.elements[3] * in_[3];
    out[1] = m_pMatrix.elements[4] * in_[0]
        + m_pMatrix.elements[5] * in_[1]
            + m_pMatrix.elements[6] * in_[2]
                + m_pMatrix.elements[7] * in_[3];
    out[2] = m_pMatrix.elements[8] * in_[0]
        + m_pMatrix.elements[9] * in_[1]
            + m_pMatrix.elements[10] * in_[2]
                + m_pMatrix.elements[11] * in_[3];
    out[3] = m_pMatrix.elements[12] * in_[0]
        + m_pMatrix.elements[13] * in_[1]
            + m_pMatrix.elements[14] * in_[2]
                + m_pMatrix.elements[15] * in_[3];

    if (out[3] == 0.0f)
    { // Check for an invalid result.
      result.x = 0.0f;
      result.y = 0.0f;
      result.z = 0.0f;
      return false;
    }

    // Scale to world coordinates.
    out[3] = 1.0f / out[3];
    result.x = out[0] * out[3];
    result.y = out[1] * out[3];
    result.z = out[2] * out[3];
    return true;

  }

  public boolean calculatePickPoints(int x, int y)
  { // Calculate positions on the near and far 3D frustum planes.
    m_bValid = true; // Have to do both in order to reset PVector on error.
    if (!gluUnProject((float)x, (float)y, 0.0f, ptStartPos)) m_bValid = false;
    if (!gluUnProject((float)x, (float)y, 1.0f, ptEndPos)) m_bValid = false;
    return m_bValid;
  }
  
}
