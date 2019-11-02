function [fft_im] = make_fftim(image)

ft = fft2( image ); 
ft = fftshift( ft ); 
ftmag = abs( ft ); 
ftmags = log( ftmag+1 ); 
ftmagbw = mat2gray( ftmags ); 

fft_im = ftmagbw; 

end 