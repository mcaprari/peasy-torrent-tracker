#!/bin/sh

# create a directory to extract to.

if [ "$1" = "help" ];then
	echo "not entering any arguments will invoke an interactive install process"
        echo "$0 [prefix current-faxien-install-dir erts-vsn]"
        exit 0
fi

if [ "$#" = "4" ];then
	PREFIX=$1
	FAXIEN_INSTALL_DIR=$2
	TARGET_ERTS_VSN=$3
else
	
	DEFAULT_PREFIX=$(dirname $0)/otp-base
	echo "Please enter the location for your OTP Base install. When doing so think about how you plan"
	echo "to use OTP Base. If you plan to use a new install for each project you work on you should"
	echo "install OTP Base into a directory named after your project like '/home/jdoe/my_project'."
	echo "Alternatively if you plan to use a single OTP Base install to house many applications and"
	echo "releases you should go with the default install of ./otp-base or a similarly generic prefix."
	echo "Please enter your install location, aka prefix, here. Use an absolute path. Default: [$DEFAULT_PREFIX] $> \c"
	read PREFIX

	if [ "$PREFIX" = "" ];then
		PREFIX=$DEFAULT_PREFIX
	fi

	if [ -e $PREFIX ];then
		echo "$PREFIX already exists"
		echo "Would you like to delete it? Answer [y|N] $> \c"
		read RESP

		case "$RESP" in
			"y")
				echo ""
				echo "    Are you sure? This will delete your entire previous install."
				echo "    Please type \"yes\" to continue $> \c"
				read SURE_RESP
				if [ "$SURE_RESP" != "yes" ];then
					echo ""
					echo "Keeping previous install, and aborting bootstrap."
					exit 0
				fi
				echo ""
				echo "Removing previous install"
				rm -rf $PREFIX
				;;
			*)
				echo "exiting the Erlware OTP Base bootstrap process"
				exit 1
				;;
		esac

	fi

	DEFAULT_FAXIEN_INSTALL_DIR="/usr/local/erlware"
	echo ""
	echo "Please enter the base directory for your Faxien install [$DEFAULT_FAXIEN_INSTALL_DIR] $> \c"
	read FAXIEN_INSTALL_DIR

	if [ "$FAXIEN_INSTALL_DIR" = "" ];then
		FAXIEN_INSTALL_DIR=$DEFAULT_FAXIEN_INSTALL_DIR
	fi

	if [ ! -e $FAXIEN_INSTALL_DIR ];then
		echo "$FAXIEN_INSTALL_DIR does not exist. Please go to code.google.com/p/faxien and install Faxien"
		exit 2
	fi

	ERL=$(which erl)
	if [ "$ERL" = "" ];then
		ERL=$FAXIEN_INSTALL_DIR/bin/erl
		echo "erl not found on path using $ERL"
	fi

	DEFAULT_TARGET_ERTS_VSN=$($ERL -s init stop | grep V | sed -e 's/.*V\([0-9\.]*\).*/\1/')
	echo ""
	echo "Please enter the erts version for the current version of Erlang you are running"
	echo "It appears to be $DEFAULT_TARGET_ERTS_VSN and this will be the default value if you choose"
	echo "not to enter one here. Default: [$DEFAULT_TARGET_ERTS_VSN] $> \c"
	read TARGET_ERTS_VSN

	if [ "$TARGET_ERTS_VSN" = "" ];then
		TARGET_ERTS_VSN=$DEFAULT_TARGET_ERTS_VSN
	fi

	export PREFIX
	export FAXIEN_INSTALL_DIR
	export TARGET_ERTS_VSN
fi
	
SKIP=`awk '/^__ARCHIVE_FOLLOWS__/ { print NR + 1; exit 0; }' $0`

echo "Extracting the Erlware OTP Base bootstrap"
echo Creating target directory $PREFIX

mkdir -p $PREFIX

if [ $? != 0 ]; then
echo "Error executing mkdir, do you have permission?"
exit 1
fi

export PREFIX=$(cd $PREFIX; pwd)

echo Untaring into $PREFIX

# Take the TGZ portion of this file and pipe it to tar.
tail -n +$SKIP $0 > $PREFIX/tmp.tar.gz
(cd $PREFIX; tar -zxf tmp.tar.gz)
rm $PREFIX/tmp.tar.gz

if [ $? != 0 ]; then
echo "Unable to untar bootstrap"
exit 1
fi

echo "Performing substitutions"
echo "FAXIEN_INSTALL_DIR=$FAXIEN_INSTALL_DIR"
echo "TARGET_ERTS_VSN=$TARGET_ERTS_VSN"

FAXIEN_INSTALL_DIR=$(echo $FAXIEN_INSTALL_DIR | sed -e "s;\/;\\\/;g")
sed -e "s;%FAXIEN_INSTALL_DIR%;$FAXIEN_INSTALL_DIR;" \
    -e "s;%TARGET_ERTS_VSN%;$TARGET_ERTS_VSN;" \
    $PREFIX/build/otp.mk > $PREFIX/build/otp.mk.tmp
 
mv $PREFIX/build/otp.mk.tmp $PREFIX/build/otp.mk

echo ""
echo "*** Erlware OTP Base is now installed ***"
echo ""
echo "For instructions on how to get started please read the README"
echo "file located inside your new Erlware OTP Base install"
echo ""

exit 0

__ARCHIVE_FOLLOWS__
� E�G �=kw۸��j�����ػ�ӯ�$N#KT����#ɛ����	Yl(�%);�i����%�u�k;�V8�Z���1 ��Q�W>y�RƲ��K+{��_.��'����������\��=�{�D*)�(6C�'S3��o�az7������[���:#�+�H
a�.X�ۃ��>���/�ƛ���X�M��l~���<�}	��'�_�/����3�� ���%OB������x"=0z�n�_�iM|�a���}["8~��W��8y|	c��ھ�۾!n4<r}�[�h��O��Ɖ�c�a��;+��sP]������5�����eO���=�h���+]�H�؟y6�1\]]e�^��,��O��_y�oڎwHϖ���H����Я����	e&��  k�C�C[�8(�3,?���"|��1���c1�\I�a�������A���8H�F�֨Iơ?�|���R�B#/^���+��?-�1w&�I`�����'	v�wQ�J�|?���R�x���Bǌ%��V�ɸP�?��X"�j�pl��b�e<�{�����0�����׆b� �h"�Q��Y��i��~X����G3��Y�\�2ݒni�x�<�չ;Ehe����_�쑶H�|�c�<����#����������yN�t8&��%�w�H�cR�l���D1*�9�/%D>��(m�E|�^S���QY�9���pd"�ؙ��QI����f����"D'�NY�~Z�r���P�KFl9؀^h@.�pJ�QD����i�F/��}zЂf!�^��`P��x1SM��k�q�x��p���@��h�vBTJ����GT��<�0Řu�LSC!�]���Ԣ�+A-�$�3t!���� ��R�9�!viiF�i��z"?�	�:�u<�cw$Dm�*qB3�&	.dv���2͇ғ!�<Gdc�ubr��>���E��CFf�X@N6;�84�����GP���"���a/�f��<��^!.>�F����Q���.k�O1�'����u>�t��.�!	� ͢�q����&�2�q�,M�nH�MS��F�lY ߼�[!e�&���_I�̥y��,wFS�4S[��~s�Zo�1����[E��d��;X7�ɁLM!�{Ɖo��40CAY�T�T*��k/��MrV3�ƹdfųP*n��d�8W���t�x(��o������L��@qP< �B'������l��X��P$�Kǒ<7��2�+cT��	�!̲k3���8�m���"4�,C^�%����+]�Ԗ��N���Ͱ�Tm��^���2t|.*�Ke]�MI�y
���)i���@�'��B)�&���\<)��8��v"n��ߔ���E_�BhAO�L�!Q3Y	�h$�ply)]?�A��011rF8͏���}(��(N4���r)J��F3�&���`�2(?
#�{uv��\���+sec���'���OQGo���7)6t�"O�̅ y�`�+���~�.I�46��pQ?�Y�R(��u��Y��y�p��hR�m5PH��o��"��$��,$}Ҳ�J/^R��0��+�;�?\:&�+�9d{]��h�Қ�"��� �/r
x����ˤ��9r���a��������M	I��o?�����K�5q�פ�F�s�9i2�V��)�;���-i
>5���bi�$��=ΕT�93���Q�}����-r�H\Ksُ,�)V�XH/#�����h,:iDwM���Ih/h%��F'�6�-)�S�k��ua���pb11�t1tE��l��D�$�	|�\P(�~�f������<	����1�/�^�XH�:�̒���Ԗ�#�H�I����&���ƀcM��8�3�U2d^w`���=/꿸`�x��@wC�����/̫�Î�I���[�XV󿕝��{X�T���(��-�h�;���ʊ��v����c�ѭOk���b����\-69���֫8�..�T��Nڅ�tXL2�o�iA] a�pV��A>�����}f�(�7���N��7S$�J;A~�vz:��N�L�>���ߡ���iW��+��� ��w�K.������8{H;ǀ��A��f����ov��z���mm���\����p�� ~����X���������G���9�0N�ڵA�w8��T�׮�5۵��CXx�*����M�S�g|P�J,��&[m���v��f��k����]�g��h��:��j[-�g��#"�CCo%?Z�zb�W�ⷂ�u�nC�n
�3F�@�}�E��)b����0�f��ҳ"��u�w���"��a�4tL'����T|
򯄠�
�� /����h\�W������¿���>�[���k��(�)(ً�P൳\Ό����>&a�E� ^���Jj_W�eC/xQ���G��ޅ�����&fhh[��~�H���Zp"���D
o��z��O�����4ؘ�UFZu�e���{g��{J[0�sI���8Aǌ�8)�Q��}5���(g�y�lN8cϖc�zo������_���|�l�♐�팓1�A*�2�h�rzE)���g=`v�ه�g������:�A��6Z�2��%��!��ێ
��H	�D���ٓ�6L�\XW��0v͋H+]`F���ڬ��a�];��O)tֈ �G�ȝ��3w�w�&H���6��`$=�����������������G��6td�����G��f���_����ߙ��A辇��*ЙQ��A=9���nф�A%b�ČI��8�6�A�y��}O�a����Ҋu�Xz�N�{��.�7�l3�Yc�e�1ޢ����<m|)��6��c�S�izhC�	OO��9����*2��VY�y@�ȁ�1b���U��"&��t从��}L6�M+�!m�1/q���	k�Z�f]���L��9���+��F��_�|T(�~�"��S��b)٭���6Y-{�Cg�����*���7[`4���nX�5�l��:5KJ̪m/}�Or����2N�Z򃸄��cZq+bz �T�b���z���z���r!Wsޝ'��Jcs3txJ"�q���
�`��X����"1�@�Q�ddw7��6(����R?߿?���g�]�)�-+ⵅ�j���^&]���VD}�B�{&T��X���\ݫuڭ��W���	QO=*M�@�&m�@��"
]�n�8�	Y�Dl_�8�ƾ�u�'3���nu���BG����`�u�%:�d�%֬��ȧL�/L7ќ­m¹�ɝr*��Qخ,�O�T����M�o�m�/K��VZ�Gخa���#���pR!V3	B�.�(_���B�?U�[��FJ���L*�R�q�7����1`��3L�b7��Ű_k�e���u�a(� ƼA<�-H�Eع��?�;u��f&X(���f1�"ƕ/��-������Qe6<K�_ڐB��3����+�P��a���׹��u_w��X�_#��ѹE���S��w���v�������[]�T����(Oq5F��M�(rp�p��Y<Zi*�E!/��Y�bu�{���^��a>��w�[������hd�*/w�X������R� -�v�����i�OU�g��v��U��Ƣ��5�N�	�a4kg�A��]����UU�8�YL�
�Ve��b��	˲���}�鷃U�v��n�:ս;n2��Q��X��6�J�Q���Gp7�o����Ǫ���#��������W���Uw���G)I�X,��B�tgm��1�e ���g3ћ���0d\�*H���U�����A=č7y�� !���u����o�G��@��x�ʿ�=ǁC�k|���\�m���x�I����+�v�nt�{���V�W�v��u��(e0�еb��B�������Po��"�u��C�bæ����5�:aV��M��N.߽!N)iq�ԉ����9z\�H{�t��IkB��m:�92�(��ixun�A${?�?��z�fr�p[]	ۆ��Z����� ַ�f��fF)j}�3������5���oK�u�>ȝ��S��RR6KݒP���K^��ԉ��.�UJ��HDl�\$��L�>G��N�`�f1VFTiI�z!%%�/�\�� �Bo�$��8N@�5y䫉>���B{g��K���c����:���g���Tg�ե��Re�|\�J}�vEBׯ����-o&
M8ѽ��A~��G+����c������Շ�^��V�h@�����6�k��g��Zg��M�u>�/�N���i����ۃ��i�e`�hu���F����c�;�v���@#jX-�O�N�^�kG�vk�a��A��6j�i�7h��ڵ�R��7����:�c��AZ��W|��q���jg��1�wO?�Zo� �q``푁�Վچ骷k��mh�Njo��E0=n��{wlpX��A��\E� �A����� ����7���k��'�^�K�G��`�����aI*�P�ҝb�0jm֧�������@%���c|���ݽ�z��%��C��Z����~�a����������?�^���L���Î�=����Qʭ ��{����V��T˻�����O��M� 'L��y�3_F�������r�䤼�@��%?���|�?����ܵ����#b'vo����(����{�C?���'}_ǳ�MU�R��KA�eϤ>zhz�8�Ff:��Z(��T����y@7����|4�:������8��. P+ZjK�PE�!��S��J�{xvzj��Z�7�T���	=�,�/�
��%p��l�?�W���.��ǲ�K�P���
�LW]��o�D�� tq7�(��Qh�_[�m���_!�~��.ޞo��n�[)�|��	#_�~|�����M���\�]xX꒢JcN���Q��%)"|TJ� ΃+��:0B���_�X�b�J�JQh	��҆?!�ե�P�M�ɍPH!9��NX/��D�X�Ԋ�b��������~�:�l������g���N�wR�j�����0O��	�2�ۺ�y}a2����2�<9������>��Su<=E+�I���hB��ѧpR��I<��i�o�,i}.��'�uy���?��h�����^u�?JY�:��w�����z�wgg��y�����>�W;i*Dltۍab��1�a�F��6T����-*t��T`�Cw|(������d)��DgS��c��;�����M�����:(.�T��q�qW�C���x�%P���J�*�7���`|�jBW(սo��	կW��|�&�i�&�/����L����`wo���G)��?	9�c�o��v���r����$�9Ʒ�gC�����6������q��wW�_�/����(喼�P���e��y�����<�]�_�]���T*���G)z/WE��JO_?���{����+�Z;��rS���)�}_c|e�����[������s�����_{���F��v���Y,Ԙ{A-Qq�Z)�ܽ%A�
2,3�.���yt��xѐ�w�JE���sz��|ߤ�)0e�7��7����B����$Rǭ���|�����̽�G.�!�[��7�7��tQ��)�'�0�&�ظ�иlL�%ޝegpb��`-3efVV^b�[v�V�zw�ێ��p�JO�^;�h��v��ܦ?s�V���>#���L� ��K�c�U]9U1��㊑�����	�ʦ�����S�����x,�튼��	sQ綊���<�r���R��I	j5J��4�/��x������E�rV:��~&&-ݽ�� Y`ay� m9T�1�o��3�w4?$���1a�'�VT�s��@��.�@J&y� 4r��c��,k�\:�53ĳ�_5�qƙ�J��:s���)���U�9��ī�Q�1��cX�j�I"2@2��z�})㞽���̢�X=�qC��(9�'�%(�%�
B�;x=����U�ϯ�J	I���We���k���-֚EI
lms���&e�#믟W��	����7����ࡧ|W���%$t��e��0p�*d��D��_4�ճ6��
����Pc-zB�y��L�� R�(S%'�������?�q�>�ہ[�A]���i>��]��$��Z�35����-"�P �l�G��,��!eW���j�� j�""n�c����R�L[���XL�Q�W�T�օ ����hG�H���Ҳ�u�����"�m�=[�锵��j���j��J#�C�=A�QyY�#.�]q�	}�uڛ&f��?<�'%�:SS�������
�����=�4����5�.>����'���W������;����Z���-//��j���
���G��/#VB-���ĕ%Ĳ(����G��5�lR�A�G#JF�%MIf����ÌE��u�BZ���)�*�P�3�S��:�`S�`Ѡ?�Hr��R����U ѫ�|��[��/��oW�����t�NfK��	�k*�q�{�n��6�7�!�a�=*��軷���q~-�Ɍlk��0�";3����+������w���Ex#��}t�]��a�X?h����R�y}��p�6�i��y����٠�~B���ׁ��{��PX�9� {�R�N,dD����6:-��ew�ĦG�;�x�������Ü(��� ����{�a4^�� Z�	����ޫ��-~:B��MK���ˈGc	����Om�w�Ok��q=Z���S�c�^�~���F~a�;7i�C�� Գn����8����z~��57N����}B�ɲ��I�<��wVޔ?��ny�����v�U�9𩂀.�_�m�<[�@�<��R)�Tw�3�:$�s� ��N���9!�/�+�ވ�Q|�i�lc̓��v��vS�K�!��UGr�ܸ�`HuR�-��1�*tէ6�]0[VcLSJM�f����(5�>�O�\�~�4��:�i� ����~�������~���A�I?J-
B��e}�(/�!l��^����1bש�v�փr�3�_&�z��0|�C��:y|�`�!T�Z.A�`[�]����%�a���ֶ���~��1�*��C�����x��j�nTb1ЙjL�m[�5���W�_�=M�Kb�˘���7���-���7[l����c.n����u(��P�,�(y�Q�R��|��T6䍢O�&X��~I���� 0���eλT� %�����_�x��?����|�8����ya��7u���|����M}���5���_��������DSE�D�D8��*7DR5ۥ7���j����u�R+�%�Q1	�É�3D���0GqY�ྲྀ���g�-�(��/F�f�����j9l��ci��E�9��s.���#�v���v�f�!V�N5Z,�-Y��ˎ�J�tQ�ǢzQ�<�����/�Jy找y|r(���kl+��~�O7k��|r~P�񦡶ޕ~-�\��ׇ��������;L���p��0�rar�%W.U������1�*3/JK%�{��ȗ>�6QU~J�Fm��K63�X��ؿ\\�����TB�A����-�t���{2ӣuD;���Ǹ/c>F��}�}]�U��)����!��hGh��l�LT��tɩ�R,��
��W=�����X�E�s�����3��|c�Vׂ�?����D��L��g"�<S�������'>Q��H��fO|׷�Lт���Hh�hh�60��6��\Vd�0[�F"*+5FK=��eY�/]?�Y��TjOgۼ���W_�2tQȩ*�K���@�tN[�a�F�UJ�iajN�l;�Qk�=�	
���ѭi��Nh��=��de&'sч/EY\�nLLT�����X�����A�zQ/"8:&��A�K�3���4�Y�Z��m�T����!��v��݇�+!4g���:yO �������PV�Xo/���x}�U�酑u+�Il�-!�-�o��;/K����W$�&�X�.X[o3�P��b�Ũ��6}�nC�w�unU"R��h>ʶ��7�4v���Fg8��J�������L+4\�~���Mۤ2��x�U�/��I�K��[K(��~�0�0�8�L}����7dГ$�V�4^�އd�����=_�%���y!���~q���q�q�@��`�9�XDa4�T�7"��d�IΎ�9>{K�I�������b����ۚ �c-L�b��x��	��Kސ��Jj/)�'�T�U��e����\�-���(ȟ&eM�*���D�>J���1��e��<�x�`�ld�o|$�(����c�b�����v�;��/�i�?�7[�����[��߹8�O�ۥ�@�&$�StRH���L%��S�3�[W�K��>5�mTi� �i��w�kdK�<i�d)M�3���U�c'���.y���&��~A*Q9?��c4	ԗ|ҫ�R�����J<��OY��4�LV>�ܡ=���r�3����(��C�ޕR���(�(#�#�bg���Bͨ��lJv�����綸/	_�e�9s �~���*��_�F��\��]T�G�_����+n��z�����;C���H��<D1з��G㽾KH����^t��NJ��OQ!{�%/A��T!<�b}_"��8���'I��*��(!�ЪR����9� �݅z�Tux�td�L���$븞ŝ�( -��<k)�j��F�?[������Vt]�1+<��}g���e�r��eL����#�o��99)�o<����"
_u(�he�P-���&�:���_&��D�c���8��"Eq�o�d�W�@IUae�S�tdR;k���~:}	��1Њx��*��*t��.�e�=Bq�#��P<��O��ꕨ�|pB6���n.
�e����8»�����Y�6�}�P�)�����C$X|� /�E�?��!V��Ց�Xe��� ����ץ4m� �k� ]���Nd���t�*�?�s�7�[�!�d��N�dy��rX�w[�P�/4Z�%ۖ�Y��>A���]���:f��fÜX�gJ��A3�P�)GPqT}���}�K�~�ƃ��ƃ~��S�<�=G-�Ke�a0��	��}wxPq�'-i�À&p�C��W*���O����F��PN�Wh�fV�o*�s-�Yꚫ've�	�3"U�:�\���x~k6�Iv&Б�V'};覡�Qj6y�/�;q�W�QG���^>�Δ	�!:�w�q��/������a���9�.%3�'rz�fYXu��d^K��Ua��QP]�b˟�y.qu��� ����;�,ax��'32�+���(��9-n��Ch�%T�r�jV�1�#=�:G�cn��Kc�@G� T�lM�3����Y���׍pK�>����P)i��Z ���f����ᎍ�^Y?{���,?w�ot}o[)���I���:%zy�Gt����^o���^/���&�?� �O!��S��~���a54�ն-��F���f��L>�E������m�j}p��w��>r�r9�c+TW�*Y���N�:�&�~J�/L�.3ǽ�d�Bu =J�7�Կ��fe��,0�(�t4��(��c�z:�Sh��ЪTj��[�����?���R �  