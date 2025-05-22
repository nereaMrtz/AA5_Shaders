
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[System.Serializable]
[PostProcess(typeof(PingPostEffectRenderer), PostProcessEvent.AfterStack, "Custom/PingPostEffect")]
public sealed class PingPostEffect : PostProcessEffectSettings
{
    public FloatParameter strength = new FloatParameter { value = 1f };
    public ColorParameter color = new ColorParameter { value = Color.yellow };
    public FloatParameter width = new FloatParameter { value = 0.1f };
    public FloatParameter speed = new FloatParameter { value = 5f };
    public FloatParameter maxDistance = new FloatParameter { value = 30f };
    public FloatParameter frequency = new FloatParameter { value = 0.25f };
}
