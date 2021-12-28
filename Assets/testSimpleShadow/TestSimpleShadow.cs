using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

class TestSimpleShadow:MonoBehaviour
{
    Camera m_renderCam;
    RenderTexture rt;

    GameObject plane;
    Material material;

    Matrix4x4 st = new Matrix4x4();
    private void Awake()
    {
        st.SetRow(0,new Vector4(0.5f, 0,   0,   0.5f));
        st.SetRow(1,new Vector4(0,    0.5f,0,   0.5f));
        st.SetRow(2,new Vector4(0,    0,   0.5f,0.5f));
        st.SetRow(3,new Vector4(0f,   0,   0,   1f));
        
        GameObject camera = new GameObject("Camera2");
        m_renderCam = camera.AddComponent<Camera>();
        m_renderCam.cullingMask = 1 << LayerMask.NameToLayer("UI");
        m_renderCam.orthographic = false;
        m_renderCam.backgroundColor = Color.white;
        camera.transform.parent = transform;
        camera.transform.localPosition = Vector3.zero;
        camera.transform.localScale = Vector3.one;
        camera.transform.localRotation = Quaternion.Euler(0,0,0);
        
        rt = new RenderTexture(512,512,24);
        m_renderCam.targetTexture = rt;
        m_renderCam.SetReplacementShader(Shader.Find("Simple/SimpleCamera"), "RenderType");

        plane = GameObject.Find("Plane");
        material = plane.GetComponent<MeshRenderer>().material;
        material.SetTexture("_depthTexture",rt);

        
        Matrix4x4 vp = GL.GetGPUProjectionMatrix(m_renderCam.projectionMatrix, false) * m_renderCam.worldToCameraMatrix;
        vp = st * vp;
        material.SetMatrix("_vpMatrix", vp);
    }

    private void Update()
    {
        
    }
}
