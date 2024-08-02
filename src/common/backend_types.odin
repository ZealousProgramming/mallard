package common

import rl "vendor:raylib"

Id :: distinct u64

// -----------------
// ---- Raylib ----
// ---------------

// MATH
PI :: rl.PI
DEG2RAD :: rl.DEG2RAD
RAD2DEG :: rl.RAD2DEG


Vec2 :: rl.Vector2
Vec3 :: rl.Vector3
Vec4 :: rl.Vector4
Quat :: rl.Quaternion
Matx :: rl.Matrix

Rect :: rl.Rectangle
Ray :: rl.Ray

Xform :: rl.Transform

Line :: struct {
	start: Vec2,
	end:   Vec2,
}

// Types
Color :: rl.Color
Image :: rl.Image
Texture :: rl.Texture
RenderTexture :: rl.RenderTexture
GlyphInfo :: rl.GlyphInfo
Font :: rl.Font
Shader :: rl.Shader
Material :: rl.Material
BoundingBox :: rl.BoundingBox
Camera2D :: rl.Camera2D
Camera3D :: rl.Camera3D

// Audio
AudioStream :: rl.AudioStream
Wave :: rl.Wave
Sound :: rl.Sound
Music :: rl.Music

FilePathList :: rl.FilePathList


// COLORS
LIGHTGRAY :: rl.LIGHTGRAY
GRAY :: rl.GRAY
DARKGRAY :: rl.DARKGRAY
YELLOW :: rl.YELLOW
GOLD :: rl.GOLD
ORANGE :: rl.ORANGE
PINK :: rl.PINK
RED :: rl.RED
MAROON :: rl.MAROON
GREEN :: rl.GREEN
LIME :: rl.LIME
DARKGREEN :: rl.DARKGREEN
SKYBLUE :: rl.SKYBLUE
BLUE :: rl.BLUE
DARKBLUE :: rl.DARKBLUE
PURPLE :: rl.PURPLE
VIOLET :: rl.VIOLET
DARKPURPLE :: rl.DARKPURPLE
BEIGE :: rl.BEIGE
BROWN :: rl.BROWN
DARKBROWN :: rl.DARKBROWN

WHITE :: rl.WHITE
BLACK :: rl.BLACK
BLANK :: rl.BLANK
MAGENTA :: rl.MAGENTA
RAYWHITE :: rl.RAYWHITE

// ENUMS
ConfigFlag :: rl.ConfigFlag
TraceLogLevel :: rl.TraceLogLevel
KeyboardKey :: rl.KeyboardKey
MouseButton :: rl.MouseButton
MouseCursor :: rl.MouseCursor
GamepadButton :: rl.GamepadButton
GamepadAxis :: rl.GamepadAxis
InputAxis :: GamepadAxis
MaterialMapIndex :: rl.MaterialMapIndex
ShaderLocationIndex :: rl.ShaderLocationIndex
ShaderUniformDataType :: rl.ShaderUniformDataType
PixelFormat :: rl.PixelFormat
TextureFilter :: rl.TextureFilter
TextureWrap :: rl.TextureWrap
FontType :: rl.FontType
BlendMode :: rl.BlendMode
CameraMode :: rl.CameraMode
CameraProjection :: rl.CameraProjection

// FUNCTIONS
// Window-related functions
_setConfigFlags :: rl.SetConfigFlags
_initWindow :: rl.InitWindow
_windowShouldClose :: rl.WindowShouldClose
_closeWindow :: rl.CloseWindow
_isWindowReady :: rl.IsWindowReady
_isWindowFullscreen :: rl.IsWindowFullscreen
_isWindowHidden :: rl.IsWindowHidden
_isWindowMinimized :: rl.IsWindowMinimized
_isWindowMaximized :: rl.IsWindowMaximized
_isWindowFocused :: rl.IsWindowFocused
_isWindowResized :: rl.IsWindowResized
_isWindowState :: rl.IsWindowState
_setWindowState :: rl.SetWindowState
_clearWindowState :: rl.ClearWindowState
_toggleFullscreen :: rl.ToggleFullscreen
_maximizeWindow :: rl.MaximizeWindow
_minimizeWindow :: rl.MinimizeWindow
_restoreWindow :: rl.RestoreWindow
_setWindowIcon :: rl.SetWindowIcon
_setWindowIcons :: rl.SetWindowIcons
_setWindowTitle :: rl.SetWindowTitle
_setWindowPosition :: rl.SetWindowPosition
_setWindowMonitor :: rl.SetWindowMonitor
_setWindowMinSize :: rl.SetWindowMinSize
_setWindowSize :: rl.SetWindowSize
_setWindowOpacity :: rl.SetWindowOpacity
_getWindowHandle :: rl.GetWindowHandle
_getScreenWidth :: rl.GetScreenWidth
_getScreenHeight :: rl.GetScreenHeight
_getRenderWidth :: rl.GetRenderWidth
_getRenderHeight :: rl.GetRenderHeight
_getMonitorCount :: rl.GetMonitorCount
_getCurrentMonitor :: rl.GetCurrentMonitor
_getMonitorPosition :: rl.GetMonitorPosition
_getMonitorWidth :: rl.GetMonitorWidth
_getMonitorHeight :: rl.GetMonitorHeight
_getMonitorPhysicalWidth :: rl.GetMonitorPhysicalWidth
_getMonitorPhysicalHeight :: rl.GetMonitorPhysicalHeight
_getMonitorRefreshRate :: rl.GetMonitorRefreshRate
_getWindowPosition :: rl.GetWindowPosition
_getWindowScaleDPI :: rl.GetWindowScaleDPI
_getMonitorName :: rl.GetMonitorName
_setClipboardText :: rl.SetClipboardText
_getClipboardText :: rl.GetClipboardText
_enableEventWaiting :: rl.EnableEventWaiting
_disableEventWaiting :: rl.DisableEventWaiting

// Custom frame control functions
_swapScreenBuffer :: rl.SwapScreenBuffer
_pollInputEvents :: rl.PollInputEvents
_waitTime :: rl.WaitTime

// Cursor-related functions
_showCursor :: rl.ShowCursor
_hideCursor :: rl.HideCursor
_isCursorHidden :: rl.IsCursorHidden
_enableCursor :: rl.EnableCursor
_disableCursor :: rl.DisableCursor
_isCursorOnScreen :: rl.IsCursorOnScreen

// Drawing-related functions
_clearBackground :: rl.ClearBackground
_beginDrawing :: rl.BeginDrawing
_endDrawing :: rl.EndDrawing
_beginMode2D :: rl.BeginMode2D
_endMode2D :: rl.EndMode2D
_beginMode3D :: rl.BeginMode3D
_endMode3D :: rl.EndMode3D
_beginTextureMode :: rl.BeginTextureMode
_endTextureMode :: rl.EndTextureMode
_beginShaderMode :: rl.BeginShaderMode
_endShaderMode :: rl.EndShaderMode
_beginBlendMode :: rl.BeginBlendMode
_endBlendMode :: rl.EndBlendMode
_beginScissorMode :: rl.BeginScissorMode
_endScissorMode :: rl.EndScissorMode

// Shader management functions
_loadShader :: rl.LoadShader
_loadShaderFromMemory :: rl.LoadShaderFromMemory
_isShaderReady :: rl.IsShaderReady
_getShaderLocation :: rl.GetShaderLocation
_getShaderLocationAttrib :: rl.GetShaderLocationAttrib
_setShaderValue :: rl.SetShaderValue
_setShaderValueV :: rl.SetShaderValueV
_setShaderValueMatrix :: rl.SetShaderValueMatrix
_setShaderValueTexture :: rl.SetShaderValueTexture
_unloadShader :: rl.UnloadShader

// Screen-space-related functions
_getMouseRay :: rl.GetMouseRay
_getCameraMatrix :: rl.GetCameraMatrix
_getCameraMatrix2D :: rl.GetCameraMatrix2D
_getWorldToScreen :: rl.GetWorldToScreen
_getScreenToWorld2D :: rl.GetScreenToWorld2D
_getWorldToScreenEx :: rl.GetWorldToScreenEx
_getWorldToScreen2D :: rl.GetWorldToScreen2D

// Timing-related functions
_setTargetFPS :: rl.SetTargetFPS
_getFPS :: rl.GetFPS
_getFrameTime :: rl.GetFrameTime
_getTime :: rl.GetTime

// Misc. functions
_getRandomValue :: rl.GetRandomValue
_setRandomSeed :: rl.SetRandomSeed

// Files management functions
_loadFileData :: rl.LoadFileData
_unloadFileData :: rl.UnloadFileData
_saveFileData :: rl.SaveFileData
_exportDataAsCode :: rl.ExportDataAsCode
_loadFileText :: rl.LoadFileText
_unloadFileText :: rl.UnloadFileText
_saveFileText :: rl.SaveFileText
_fileExists :: rl.FileExists
_directoryExists :: rl.DirectoryExists
_isFileExtension :: rl.IsFileExtension
_getFileLength :: rl.GetFileLength
_getFileExtension :: rl.GetFileExtension
_getFileName :: rl.GetFileName
_getFileNameWithoutExt :: rl.GetFileNameWithoutExt
_getDirectoryPath :: rl.GetDirectoryPath
_getPrevDirectoryPath :: rl.GetPrevDirectoryPath
_getWorkingDirectory :: rl.GetWorkingDirectory
_getApplicationDirectory :: rl.GetApplicationDirectory
_changeDirectory :: rl.ChangeDirectory
_isPathFile :: rl.IsPathFile
_loadDirectoryFiles :: rl.LoadDirectoryFiles
_loadDirectoryFilesEx :: rl.LoadDirectoryFilesEx
_unloadDirectoryFiles :: rl.UnloadDirectoryFiles
_isFileDropped :: rl.IsFileDropped
_loadDroppedFiles :: rl.LoadDroppedFiles
_unloadDroppedFiles :: rl.UnloadDroppedFiles
_getFileModTime :: rl.GetFileModTime

// Input-related functions: keyboard
_isKeyPressed :: rl.IsKeyPressed
_isKeyDown :: rl.IsKeyDown
_isKeyReleased :: rl.IsKeyReleased
_isKeyUp :: rl.IsKeyUp
_setExitKey :: rl.SetExitKey
_getKeyPressed :: rl.GetKeyPressed
_getCharPressed :: rl.GetCharPressed

// Input-related functions: gamepads
_isGamepadAvailable :: rl.IsGamepadAvailable
_getGamepadName :: rl.GetGamepadName
_isGamepadButtonPressed :: rl.IsGamepadButtonPressed
_isGamepadButtonDown :: rl.IsGamepadButtonDown
_isGamepadButtonReleased :: rl.IsGamepadButtonReleased
_isGamepadButtonUp :: rl.IsGamepadButtonUp
_getGamepadButtonPressed :: rl.GetGamepadButtonPressed
_getGamepadAxisCount :: rl.GetGamepadAxisCount
_getGamepadAxisMovement :: rl.GetGamepadAxisMovement
_setGamepadMappings :: rl.SetGamepadMappings

// Input-related functions: mouse
_isMouseButtonPressed :: rl.IsMouseButtonPressed
_isMouseButtonDown :: rl.IsMouseButtonDown
_isMouseButtonReleased :: rl.IsMouseButtonReleased
_isMouseButtonUp :: rl.IsMouseButtonUp
_getMouseX :: rl.GetMouseX
_getMouseY :: rl.GetMouseY
_getMousePosition :: rl.GetMousePosition
_getMouseDelta :: rl.GetMouseDelta
_setMousePosition :: rl.SetMousePosition
_setMouseOffset :: rl.SetMouseOffset
_setMouseScale :: rl.SetMouseScale
_getMouseWheelMove :: rl.GetMouseWheelMove
_getMouseWheelMoveV :: rl.GetMouseWheelMoveV
_setMouseCursor :: rl.SetMouseCursor

// Camera System Functions (Module: camera)
_updateCamera :: rl.UpdateCamera
_updateCameraPro :: rl.UpdateCameraPro

// Basic Shapes Drawing Functions (Module: shapes)
_setShapesTexture :: rl.SetShapesTexture
_drawPixel :: rl.DrawPixel
_drawPixelV :: rl.DrawPixelV
_drawLine :: rl.DrawLine
_drawLineV :: rl.DrawLineV
_drawLineEx :: rl.DrawLineEx
_drawLineStrip :: rl.DrawLineStrip
_drawCircle :: rl.DrawCircle
_drawCircleSector :: rl.DrawCircleSector
_drawCircleSectorLines :: rl.DrawCircleSectorLines
_drawCircleGradient :: rl.DrawCircleGradient
_drawCircleV :: rl.DrawCircleV
_drawCircleLines :: rl.DrawCircleLines
_drawEllipse :: rl.DrawEllipse
_drawEllipseLines :: rl.DrawEllipseLines
_drawRing :: rl.DrawRing
_drawRingLines :: rl.DrawRingLines
_drawRect :: rl.DrawRectangle
_drawRectV :: rl.DrawRectangleV
_drawRectRec :: rl.DrawRectangleRec
_drawRectPro :: rl.DrawRectanglePro
_drawRectGradientV :: rl.DrawRectangleGradientV
_drawRectGradientH :: rl.DrawRectangleGradientH
_drawRectGradientEx :: rl.DrawRectangleGradientEx
_drawRectLines :: rl.DrawRectangleLines
_drawRectLinesEx :: rl.DrawRectangleLinesEx
_drawRectRounded :: rl.DrawRectangleRounded
_drawRectRoundedLines :: rl.DrawRectangleRoundedLines
_drawTriangle :: rl.DrawTriangle
_drawTriangleLines :: rl.DrawTriangleLines
_drawTriangleFan :: rl.DrawTriangleFan
_drawTriangleStrip :: rl.DrawTriangleStrip
_drawPoly :: rl.DrawPoly
_drawPolyLines :: rl.DrawPolyLines
_drawPolyLinesEx :: rl.DrawPolyLinesEx

// Collision-checks
_checkCollisionRecs :: rl.CheckCollisionRecs
_checkCollisionCircles :: rl.CheckCollisionCircles
_checkCollisionCircleRec :: rl.CheckCollisionCircleRec
_checkCollisionPointRec :: rl.CheckCollisionPointRec
_checkCollisionPointCircle :: rl.CheckCollisionPointCircle
_checkCollisionPointTriangle :: rl.CheckCollisionPointTriangle
_checkCollisionPointPoly :: rl.CheckCollisionPointPoly
_checkCollisionLines :: rl.CheckCollisionLines
_checkCollisionPointLine :: rl.CheckCollisionPointLine
_getCollisionRec :: rl.GetCollisionRec

// Image loading functions
_loadImage :: rl.LoadImage
_loadImageRaw :: rl.LoadImageRaw
_loadImageAnim :: rl.LoadImageAnim
_loadImageFromMemory :: rl.LoadImageFromMemory
_loadImageFromTexture :: rl.LoadImageFromTexture
_loadImageFromScreen :: rl.LoadImageFromScreen
_isImageReady :: rl.IsImageReady
_unloadImage :: rl.UnloadImage
_exportImage :: rl.ExportImage
_exportImageAsCode :: rl.ExportImageAsCode

// Image generation functions
_genImageColor :: rl.GenImageColor
_genImageGradientRadial :: rl.GenImageGradientRadial
_genImageChecked :: rl.GenImageChecked
_genImageWhiteNoise :: rl.GenImageWhiteNoise
_genImagePerlinNoise :: rl.GenImagePerlinNoise
_genImageCellular :: rl.GenImageCellular
_genImageText :: rl.GenImageText

// Image manipulation functions
_imageCopy :: rl.ImageCopy
_imageFromImage :: rl.ImageFromImage
_imageText :: rl.ImageText
_imageTextEx :: rl.ImageTextEx
_imageFormat :: rl.ImageFormat
_imageToPOT :: rl.ImageToPOT
_imageCrop :: rl.ImageCrop
_imageAlphaCrop :: rl.ImageAlphaCrop
_imageAlphaClear :: rl.ImageAlphaClear
_imageAlphaMask :: rl.ImageAlphaMask
_imageAlphaPremultiply :: rl.ImageAlphaPremultiply
_imageBlurGaussian :: rl.ImageBlurGaussian
_imageResize :: rl.ImageResize
_imageResizeNN :: rl.ImageResizeNN
_imageResizeCanvas :: rl.ImageResizeCanvas
_imageMipmaps :: rl.ImageMipmaps
_imageDither :: rl.ImageDither
_imageFlipVertical :: rl.ImageFlipVertical
_imageFlipHorizontal :: rl.ImageFlipHorizontal
_imageRotateCW :: rl.ImageRotateCW
_imageRotateCCW :: rl.ImageRotateCCW
_imageColorTint :: rl.ImageColorTint
_imageColorInvert :: rl.ImageColorInvert
_imageColorGrayscale :: rl.ImageColorGrayscale
_imageColorContrast :: rl.ImageColorContrast
_imageColorBrightness :: rl.ImageColorBrightness
_imageColorReplace :: rl.ImageColorReplace
_loadImageColors :: rl.LoadImageColors
_loadImagePalette :: rl.LoadImagePalette
_unloadImageColors :: rl.UnloadImageColors
_unloadImagePalette :: rl.UnloadImagePalette
_getImageAlphaBorder :: rl.GetImageAlphaBorder
_getImageColor :: rl.GetImageColor

// Image drawing functions
_imageClearBackground :: rl.ImageClearBackground
_imageDrawPixel :: rl.ImageDrawPixel
_imageDrawPixelV :: rl.ImageDrawPixelV
_imageDrawLine :: rl.ImageDrawLine
_imageDrawLineV :: rl.ImageDrawLineV
_imageDrawCircle :: rl.ImageDrawCircle
_imageDrawCircleV :: rl.ImageDrawCircleV
_imageDrawCircleLines :: rl.ImageDrawCircleLines
_imageDrawCircleLinesV :: rl.ImageDrawCircleLinesV
_imageDrawRectangle :: rl.ImageDrawRectangle
_imageDrawRectangleV :: rl.ImageDrawRectangleV
_imageDrawRectangleRec :: rl.ImageDrawRectangleRec
_imageDrawRectangleLines :: rl.ImageDrawRectangleLines
_imageDraw :: rl.ImageDraw
_imageDrawText :: rl.ImageDrawText
_imageDrawTextEx :: rl.ImageDrawTextEx

// Texture loading functions
_loadTexture :: rl.LoadTexture
_loadTextureFromImage :: rl.LoadTextureFromImage
_loadTextureCubemap :: rl.LoadTextureCubemap
_loadRenderTexture :: rl.LoadRenderTexture
_isTextureReady :: rl.IsTextureReady
_unloadTexture :: rl.UnloadTexture
_isRenderTextureReady :: rl.IsRenderTextureReady
_unloadRenderTexture :: rl.UnloadRenderTexture
_updateTexture :: rl.UpdateTexture
_updateTextureRec :: rl.UpdateTextureRec

// Texture configuration functions
_genTextureMipmaps :: rl.GenTextureMipmaps
_setTextureFilter :: rl.SetTextureFilter
_setTextureWrap :: rl.SetTextureWrap

// Texture drawing functions
_drawTexture :: rl.DrawTexture
_drawTextureV :: rl.DrawTextureV
_drawTextureEx :: rl.DrawTextureEx
_drawTextureRec :: rl.DrawTextureRec
_drawTexturePro :: rl.DrawTexturePro
_drawTextureNPatch :: rl.DrawTextureNPatch

// Color/pixel related functions
_fade :: rl.Fade
_colorToInt :: rl.ColorToInt
_colorNormalize :: rl.ColorNormalize
_colorFromNormalized :: rl.ColorFromNormalized
_colorToHSV :: rl.ColorToHSV
_colorFromHSV :: rl.ColorFromHSV
_colorTint :: rl.ColorTint
_colorBrightness :: rl.ColorBrightness
_colorContrast :: rl.ColorContrast
_colorAlpha :: rl.ColorAlpha
_colorAlphaBlend :: rl.ColorAlphaBlend
_getColor :: rl.GetColor
_getPixelColor :: rl.GetPixelColor
_setPixelColor :: rl.SetPixelColor
_getPixelDataSize :: rl.GetPixelDataSize

// Font loading/unloading functions
_getFontDefault :: rl.GetFontDefault
_loadFont :: rl.LoadFont
_loadFontEx :: rl.LoadFontEx
_loadFontFromImage :: rl.LoadFontFromImage
_loadFontFromMemory :: rl.LoadFontFromMemory
_isFontReady :: rl.IsFontReady
_loadFontData :: rl.LoadFontData
_genImageFontAtlas :: rl.GenImageFontAtlas
_unloadFontData :: rl.UnloadFontData
_unloadFont :: rl.UnloadFont
_exportFontAsCode :: rl.ExportFontAsCode

// Text drawing functions
_drawFPS :: rl.DrawFPS
_drawText :: rl.DrawText
_drawTextEx :: rl.DrawTextEx
_drawTextPro :: rl.DrawTextPro
_drawTextCodepoint :: rl.DrawTextCodepoint
_drawTextCodepoints :: rl.DrawTextCodepoints

// Text font info functions
_measureText :: rl.MeasureText
_measureTextEx :: rl.MeasureTextEx
_getGlyphIndex :: rl.GetGlyphIndex
_getGlyphInfo :: rl.GetGlyphInfo
_getGlyphAtlasRec :: rl.GetGlyphAtlasRec

// Text codepoints management functions (unicode characters)
_loadUTF8 :: rl.LoadUTF8
_unloadUTF8 :: rl.UnloadUTF8
_loadCodepoints :: rl.LoadCodepoints
_unloadCodepoints :: rl.UnloadCodepoints
_getCodepointCount :: rl.GetCodepointCount
_getCodepoint :: rl.GetCodepoint
_getCodepointNext :: rl.GetCodepointNext
_getCodepointPrevious :: rl.GetCodepointPrevious
_codepointToUTF8 :: rl.CodepointToUTF8

// Text strings management functions (no UTF-8 strings, only byte chars)
_textCopy :: rl.TextCopy
_textIsEqual :: rl.TextIsEqual
_textLength :: rl.TextLength

// TextFormat is defined at the bottom of this file
_textSubtext :: rl.TextSubtext
_textReplace :: rl.TextReplace
_textInsert :: rl.TextInsert
_textJoin :: rl.TextJoin
_textSplit :: rl.TextSplit
_textAppend :: rl.TextAppend
_textFindIndex :: rl.TextFindIndex
_textToUpper :: rl.TextToUpper
_textToLower :: rl.TextToLower
_textToPascal :: rl.TextToPascal
_textToInteger :: rl.TextToInteger

// Basic geometric 3D shapes drawing functions
_drawLine3D :: rl.DrawLine3D
_drawPoint3D :: rl.DrawPoint3D
_drawCircle3D :: rl.DrawCircle3D
_drawTriangle3D :: rl.DrawTriangle3D
_drawTriangleStrip3D :: rl.DrawTriangleStrip3D
_drawCube :: rl.DrawCube
_drawCubeV :: rl.DrawCubeV
_drawCubeWires :: rl.DrawCubeWires
_drawCubeWiresV :: rl.DrawCubeWiresV
_drawSphere :: rl.DrawSphere
_drawSphereEx :: rl.DrawSphereEx
_drawSphereWires :: rl.DrawSphereWires
_drawCylinder :: rl.DrawCylinder
_drawCylinderEx :: rl.DrawCylinderEx
_drawCylinderWires :: rl.DrawCylinderWires
_drawCylinderWiresEx :: rl.DrawCylinderWiresEx
_drawCapsule :: rl.DrawCapsule
_drawCapsuleWires :: rl.DrawCapsuleWires
_drawPlane :: rl.DrawPlane
_drawRay :: rl.DrawRay
_drawGrid :: rl.DrawGrid

// Audio device management functions
_initAudioDevice :: rl.InitAudioDevice
_closeAudioDevice :: rl.CloseAudioDevice
_isAudioDeviceReady :: rl.IsAudioDeviceReady
_setMasterVolume :: rl.SetMasterVolume

// Wave/Sound loading/unloading functions
_loadWave :: rl.LoadWave
_loadWaveFromMemory :: rl.LoadWaveFromMemory
_isWaveReady :: rl.IsWaveReady
_loadSound :: rl.LoadSound
_loadSoundFromWave :: rl.LoadSoundFromWave
_isSoundReady :: rl.IsSoundReady
_updateSound :: rl.UpdateSound
_unloadWave :: rl.UnloadWave
_unloadSound :: rl.UnloadSound
_exportWave :: rl.ExportWave
_exportWaveAsCode :: rl.ExportWaveAsCode

// Wave/Sound management functions
_playSound :: rl.PlaySound
_stopSound :: rl.StopSound
_pauseSound :: rl.PauseSound
_resumeSound :: rl.ResumeSound
_isSoundPlaying :: rl.IsSoundPlaying
_setSoundVolume :: rl.SetSoundVolume
_setSoundPitch :: rl.SetSoundPitch
_setSoundPan :: rl.SetSoundPan
_waveCopy :: rl.WaveCopy
_waveCrop :: rl.WaveCrop
_waveFormat :: rl.WaveFormat
_loadWaveSamples :: rl.LoadWaveSamples
_unloadWaveSamples :: rl.UnloadWaveSamples

// Music management functions
_loadMusicStream :: rl.LoadMusicStream
_loadMusicStreamFromMemory :: rl.LoadMusicStreamFromMemory
_isMusicReady :: rl.IsMusicReady
_unloadMusicStream :: rl.UnloadMusicStream
_playMusicStream :: rl.PlayMusicStream
_isMusicStreamPlaying :: rl.IsMusicStreamPlaying
_updateMusicStream :: rl.UpdateMusicStream
_stopMusicStream :: rl.StopMusicStream
_pauseMusicStream :: rl.PauseMusicStream
_resumeMusicStream :: rl.ResumeMusicStream
_seekMusicStream :: rl.SeekMusicStream
_setMusicVolume :: rl.SetMusicVolume
_setMusicPitch :: rl.SetMusicPitch
_setMusicPan :: rl.SetMusicPan
_getMusicTimeLength :: rl.GetMusicTimeLength
_getMusicTimePlayed :: rl.GetMusicTimePlayed

// AudioStream management functions
_LoadAudioStream :: rl.LoadAudioStream
_IsAudioStreamReady :: rl.IsAudioStreamReady
_UnloadAudioStream :: rl.UnloadAudioStream
_UpdateAudioStream :: rl.UpdateAudioStream
_IsAudioStreamProcessed :: rl.IsAudioStreamProcessed
_PlayAudioStream :: rl.PlayAudioStream
_PauseAudioStream :: rl.PauseAudioStream
_ResumeAudioStream :: rl.ResumeAudioStream
_IsAudioStreamPlaying :: rl.IsAudioStreamPlaying
_StopAudioStream :: rl.StopAudioStream
_SetAudioStreamVolume :: rl.SetAudioStreamVolume
_SetAudioStreamPitch :: rl.SetAudioStreamPitch
_SetAudioStreamPan :: rl.SetAudioStreamPan
_SetAudioStreamBufferSizeDefault :: rl.SetAudioStreamBufferSizeDefault
_SetAudioStreamCallback :: rl.SetAudioStreamCallback
_AttachAudioStreamProcessor :: rl.AttachAudioStreamProcessor
_DetachAudioStreamProcessor :: rl.DetachAudioStreamProcessor
_AttachAudioMixedProcessor :: rl.AttachAudioMixedProcessor
_DetachAudioMixedProcessor :: rl.DetachAudioMixedProcessor
