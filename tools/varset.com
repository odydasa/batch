���������             ��������             �
VARSET 1.2 (c) 2001-2002, Horst Schaeffer
sets variable through CALL VAR SET .. construct (see TXT file)
with LFN support (Win9x)
Syntax: CALL VAR SET varname=expression [options]
Expressions:
	DATE|TIME OF file
	FILES|DIRS OF filespec (wildcards)
	SIZE OF file(s)
	LINES OF file
	VOL OF drive
	DRIVE|-DRIVE OF filespec
	NAME OF filespec
	EXT|-EXT OF filespec
	LFN|SFN OF file or folder
	FULL OF filespec
	STRING(p,l) string
	(arithmetic)
Options:
	/U|L upper|lower case
	/T   thousands separator
	/Rn  right align (total size=n)
	/Zn  fixed length with leading zeros
R�, K��&� ��� ��u#&�= u�]�ʉ�&�C�G<\u�τ�u�����Z� -,�]*���8�!����D���D��Ê��� u����u�ӊ.���� �誊�� �誊�<dr�20,d�<Pr�19GG*��
��00��      <w<ar<zw$��S�  :�u����� tC��r�[�<w<Ar<Zw �S�  :�u����� tC��r�[ù  ���t�A���+ۀ9 t� ��:uC��Í0�+�f+�f�ʱ
f��f��t��u*���SR���Z[�*��(t	��u�����0�ª�fQfR�< t�Nf+�f��f�Њ��0r��
sF�
f��f�s�fZfYÿ)�< t�N<(uF�<t�<)t���� ÿ)�<t�</u�|9w�<"t�:�t���� �)�<-u�E<(t<0r<9w���� �< t�N*�+ɿ��<t7�</u��"u-�< u���� <"u2���<?t<*u�z<\u:�tɈŪ��*�)ϰ ��RW�ֿ����`q��!��_Z��zt�X�ñ���r= qt��' �N��!r
�� �� ��X�ÉӀ? u�*�!�Ӂ�l�����r� Њ���� Њ�����P��ÉӀ? u�,�!���r�������*����:���*����            �N�7 �!r(�� uf�tf�� f|��>� .tf�x�O���WR���7 � �Nq��!Z_r�= qt���W���uf�tf�U f|��},.tf�x� �Oq��!sո�q��!_���f�t�����f�x���f�fHf�f���V��^�����������f�|f+ɹ ��BMu������BKu����>t u�X��H��+ۉ֬<\u+�<.u���u�N������t��� ������t�G� ������֬<\t<:u���u�R+ۉր<.u��< tF���t� ^����։�� ��Y�<Ar	��:uFF���!A�:�� ,@�Ѐ<\t�\����G�!��s	�XO�}��@ � �O�<\t�< t	�}�\t�\�����u��߉�*�*ɬ��u�<.u
��\u��G���t<\t��t*�����NO�}�:t
O�=\u���u��}�:u�<\t�\�����u�멉֋<Ar��:t�X��!A�:�É֋<Ar��:uFF����ր|:t�D:�D*.�D* � �N��!s�Xþ� +ɬ��t<.u��u� �����ñ�����r= qt���X���zt�Xñ��r= qt�� �=��!s�XË�f+����� x�?��!P�����
��ufE���X= xtڴ>��!f���A��+�+ɀ< t�q���tH�ج< t�<,t�N�]�����uI�օ�t	�< tFKu�+�9�t�8 tC���  ����Xì< t�N<-uFP��Z��-uf���fS�< t�N<(uF�l �<)uF����f[�fS���P�< t�N��X��*t
��/t��\u=Ff��Q��Yf�f���*uf���f�9�t�X�f��tf����\uf����X�f[�fS��P�< t�N��X��+t��-u!Ff��Q��Yf���+uf��f)�q�X��f[������t�X�À>Xt�f+�f�yf���-G�X���.BAT  ����rӬ< t���V��
����u�^��=��!r���
�ؿ���� �?��!��=
uG�=@t����+�*��B��!+ɴ@��!ì< t�N<t��</u����<Uu�(��<Lu�(��<Tu�(��<Rt	<Zu�)0��=P v�P �*�É���+,t��*+�v��ǉ��ON��GF�)O�;�u��>,��(t���(t���G;�r��  OF DATE   TIME   JNUMBER FILES  DIRS   SIZE   &EXT    ~-EXT   �NAME   �DRIVE  �-DRIVE �VOL    �FULL   �LFN    �SFN    �LINES  	STRING n	�< t�N���4�t��	��Wr��ËE���VARSET syntax error
�P�.� �@��!�X� � �w������ �< t�N<t�</t�<=t�:-u
F�< t�N����< t�N<tƿ]�<=t< v����=��>,�< t�<=t�N�Y�r���< t�N�����i���"�r����
������)�>,���;��
��Y��)ы�
�@��!��t�>��!�L�X�! SET 