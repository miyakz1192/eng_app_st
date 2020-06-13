function setVideo(path)
{
	var video = document.getElementById("video");
	if(video.canPlayType("application/vnd.apple.mpegurl"))
	{
		video.src = path;
		return;
	}
	if(Hls.isSupported( ))
	{
		var hls = new Hls( );
		hls.loadSource(path);
		hls.attachMedia(video);
	}
	return;
}
