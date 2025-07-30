using UnityEngine;

namespace WrapShader
{
    /// <summary>
    /// A simple static class that provides utility to control the wrapping effect
    /// of the environment
    /// </summary>
    public static class WrappingController
    {
        static public void EnableWrapping() => Shader.SetGlobalFloat("_DisableWrapping", 0);

        static public void DisableWrapping() => Shader.SetGlobalFloat("_DisableWrapping", 1);
    }
}