PGDMP         ;        	        x            projectmann    12.3    13.0 �    =           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            >           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            @           1262    16395    projectmann    DATABASE     V   CREATE DATABASE projectmann WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C';
    DROP DATABASE projectmann;
                projectmann    false            �            1259    16396    usuario    TABLE     )  CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    nombre character varying(30) NOT NULL,
    apellido character varying(30) NOT NULL,
    clave character varying(100) NOT NULL,
    fk_rol smallint NOT NULL,
    nombre_usuario character varying(10) NOT NULL,
    email character varying(35) NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_DATE NOT NULL,
    fecha_modificacion timestamp without time zone,
    fk_usuario_modifica integer,
    fk_usuario_crea integer
);
    DROP TABLE public.usuario;
       public         heap    projectmann    false            �            1255    16401 +   login(character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.login(email character varying, pass character varying) RETURNS SETOF public.usuario
    LANGUAGE sql
    AS $$
	SELECT 
		u.id_usuario, 
		u.nombre, 
		u.apellido, 
		u.clave, 
		u.fk_rol, 
		u.nombre_usuario, 
		u.email, 
		u.estado, 
		u.fecha_creacion, 
		u.fecha_modificacion, 
		u.fk_usuario_crea,
		u.fk_usuario_modifica 
	FROM public.usuario AS u
	WHERE u.clave = pass AND u.email = email AND u.estado = true;
$$;
 M   DROP FUNCTION public.login(email character varying, pass character varying);
       public          projectmann    false    202            �            1255    16402    obtener_items_trabajo()    FUNCTION       CREATE FUNCTION public.obtener_items_trabajo() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
	DECLARE RES REFCURSOR;
	BEGIN
		OPEN RES FOR
		SELECT
			tit.nombre tipo_de_trabajo,
			it.titulo,
			it.descripcion,
			e.nombre estado,
			u.nombre_usuario asignado_a
		FROM item_trabajo it 
		INNER JOIN tipo_item_trabajo tit ON tit.id_tipo_item_trabajo = it.fk_tipo_item_trabajo 
		INNER JOIN estado e ON e.id_estado = it.fk_estado
		INNER JOIN usuario u ON u.id_usuario = it.fk_asignado_a;
		
		RETURN RES;
	END;
$$;
 .   DROP FUNCTION public.obtener_items_trabajo();
       public          projectmann    false            �            1255    16403    obtener_proyectos()    FUNCTION     �  CREATE FUNCTION public.obtener_proyectos() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
	DECLARE RES REFCURSOR;
	BEGIN
		OPEN RES FOR
		SELECT
			proyecto.nombre_proyecto,
			proyecto.fecha_creacion,
			e.nombre estado,
			c.nombre cliente,
			u.nombre_usuario usuario_crea
		FROM proyecto 
		INNER JOIN estado e ON e.id_estado = proyecto.fk_estado
		INNER JOIN cliente c ON c.id_cliente = proyecto.fk_cliente
		INNER JOIN usuario u ON u.id_usuario = proyecto.fk_usuario_crea;
		
		RETURN RES;
	END;
$$;
 *   DROP FUNCTION public.obtener_proyectos();
       public          projectmann    false            �            1259    16404    cliente    TABLE       CREATE TABLE public.cliente (
    id_cliente integer NOT NULL,
    nombre character varying(100) NOT NULL,
    telefono character varying(9),
    celular character varying(13) NOT NULL,
    email character varying(35) NOT NULL,
    fk_tipo_identificacion smallint NOT NULL,
    identificacion character varying(30) NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_DATE NOT NULL,
    fecha_modificacion timestamp without time zone,
    fk_usuario_modifica integer,
    fk_usuario_crea integer
);
    DROP TABLE public.cliente;
       public         heap    projectmann    false            �            1259    16408    cliente_id_cliente_seq    SEQUENCE     �   CREATE SEQUENCE public.cliente_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.cliente_id_cliente_seq;
       public          projectmann    false    203            A           0    0    cliente_id_cliente_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.cliente_id_cliente_seq OWNED BY public.cliente.id_cliente;
          public          projectmann    false    204            �            1259    16410 
   comentario    TABLE     Q  CREATE TABLE public.comentario (
    id_comentario bigint NOT NULL,
    contenido character varying(1000) NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_DATE NOT NULL,
    fecha_modificacion timestamp without time zone NOT NULL,
    fk_usuario_modifica integer NOT NULL,
    fk_usuario_crea integer NOT NULL
);
    DROP TABLE public.comentario;
       public         heap    projectmann    false            �            1259    16417    comentario_id_comentario_seq    SEQUENCE     �   CREATE SEQUENCE public.comentario_id_comentario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.comentario_id_comentario_seq;
       public          projectmann    false    205            B           0    0    comentario_id_comentario_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.comentario_id_comentario_seq OWNED BY public.comentario.id_comentario;
          public          projectmann    false    206            �            1259    16419    comentario_item_trabajo    TABLE     �   CREATE TABLE public.comentario_item_trabajo (
    id_comentario_item_trabajo bigint NOT NULL,
    fk_comentario bigint NOT NULL,
    fk_item_trabajo integer NOT NULL
);
 +   DROP TABLE public.comentario_item_trabajo;
       public         heap    projectmann    false            �            1259    16422 6   comentario_item_trabajo_id_comentario_item_trabajo_seq    SEQUENCE     �   CREATE SEQUENCE public.comentario_item_trabajo_id_comentario_item_trabajo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 M   DROP SEQUENCE public.comentario_item_trabajo_id_comentario_item_trabajo_seq;
       public          projectmann    false    207            C           0    0 6   comentario_item_trabajo_id_comentario_item_trabajo_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.comentario_item_trabajo_id_comentario_item_trabajo_seq OWNED BY public.comentario_item_trabajo.id_comentario_item_trabajo;
          public          projectmann    false    208            �            1259    16424    comentario_proyecto    TABLE     �   CREATE TABLE public.comentario_proyecto (
    id_comentario_proyecto bigint NOT NULL,
    fk_comentario bigint NOT NULL,
    fk_proyecto integer NOT NULL
);
 '   DROP TABLE public.comentario_proyecto;
       public         heap    projectmann    false            �            1259    16427 .   comentario_proyecto_id_comentario_proyecto_seq    SEQUENCE     �   CREATE SEQUENCE public.comentario_proyecto_id_comentario_proyecto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE public.comentario_proyecto_id_comentario_proyecto_seq;
       public          projectmann    false    209            D           0    0 .   comentario_proyecto_id_comentario_proyecto_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.comentario_proyecto_id_comentario_proyecto_seq OWNED BY public.comentario_proyecto.id_comentario_proyecto;
          public          projectmann    false    210            �            1259    16429    comentario_ticket    TABLE     �   CREATE TABLE public.comentario_ticket (
    id_comentario_ticket bigint NOT NULL,
    fk_comentario bigint NOT NULL,
    fk_ticket integer NOT NULL
);
 %   DROP TABLE public.comentario_ticket;
       public         heap    projectmann    false            �            1259    16432 *   comentario_ticket_id_comentario_ticket_seq    SEQUENCE     �   CREATE SEQUENCE public.comentario_ticket_id_comentario_ticket_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 A   DROP SEQUENCE public.comentario_ticket_id_comentario_ticket_seq;
       public          projectmann    false    211            E           0    0 *   comentario_ticket_id_comentario_ticket_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public.comentario_ticket_id_comentario_ticket_seq OWNED BY public.comentario_ticket.id_comentario_ticket;
          public          projectmann    false    212            �            1259    16434    estado    TABLE     k   CREATE TABLE public.estado (
    id_estado smallint NOT NULL,
    nombre character varying(20) NOT NULL
);
    DROP TABLE public.estado;
       public         heap    projectmann    false            �            1259    16437    estado_id_estado_seq    SEQUENCE     �   CREATE SEQUENCE public.estado_id_estado_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.estado_id_estado_seq;
       public          projectmann    false    213            F           0    0    estado_id_estado_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.estado_id_estado_seq OWNED BY public.estado.id_estado;
          public          projectmann    false    214            �            1259    16439    item_inventario    TABLE     �  CREATE TABLE public.item_inventario (
    id_item_inventario integer NOT NULL,
    fk_asignado_a integer,
    nombre_software character varying(30) NOT NULL,
    licencia character varying(500),
    version character varying(10),
    fecha_creacion timestamp without time zone DEFAULT CURRENT_DATE NOT NULL,
    fecha_modificacion timestamp without time zone NOT NULL,
    fk_usuario_modifica integer NOT NULL,
    fk_usuario_crea integer NOT NULL
);
 #   DROP TABLE public.item_inventario;
       public         heap    projectmann    false            �            1259    16446 &   item_inventario_id_item_inventario_seq    SEQUENCE     �   CREATE SEQUENCE public.item_inventario_id_item_inventario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public.item_inventario_id_item_inventario_seq;
       public          projectmann    false    215            G           0    0 &   item_inventario_id_item_inventario_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public.item_inventario_id_item_inventario_seq OWNED BY public.item_inventario.id_item_inventario;
          public          projectmann    false    216            �            1259    16448    item_trabajo    TABLE     �  CREATE TABLE public.item_trabajo (
    id_item_trabajo integer NOT NULL,
    fk_tipo_item_trabajo smallint NOT NULL,
    titulo character varying(70) NOT NULL,
    descripcion character varying(1000) NOT NULL,
    fk_estado smallint NOT NULL,
    fk_asignado_a integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_DATE NOT NULL,
    fecha_modificacion timestamp without time zone NOT NULL,
    fk_usuario_modifica integer NOT NULL,
    fk_usuario_crea integer NOT NULL
);
     DROP TABLE public.item_trabajo;
       public         heap    projectmann    false            �            1259    16455    item_trabajo_enlace    TABLE     �   CREATE TABLE public.item_trabajo_enlace (
    id_item_trabajo_enlace integer NOT NULL,
    fk_item_trabajo_1 integer NOT NULL,
    fk_item_trabajo_2 integer NOT NULL,
    fk_tipo_enlace smallint NOT NULL
);
 '   DROP TABLE public.item_trabajo_enlace;
       public         heap    projectmann    false            �            1259    16458 .   item_trabajo_enlace_id_item_trabajo_enlace_seq    SEQUENCE     �   CREATE SEQUENCE public.item_trabajo_enlace_id_item_trabajo_enlace_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE public.item_trabajo_enlace_id_item_trabajo_enlace_seq;
       public          projectmann    false    218            H           0    0 .   item_trabajo_enlace_id_item_trabajo_enlace_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.item_trabajo_enlace_id_item_trabajo_enlace_seq OWNED BY public.item_trabajo_enlace.id_item_trabajo_enlace;
          public          projectmann    false    219            �            1259    16460     item_trabajo_id_item_trabajo_seq    SEQUENCE     �   CREATE SEQUENCE public.item_trabajo_id_item_trabajo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.item_trabajo_id_item_trabajo_seq;
       public          projectmann    false    217            I           0    0     item_trabajo_id_item_trabajo_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.item_trabajo_id_item_trabajo_seq OWNED BY public.item_trabajo.id_item_trabajo;
          public          projectmann    false    220            �            1259    16462    item_trabajo_proyecto    TABLE     �   CREATE TABLE public.item_trabajo_proyecto (
    id_item_trabajo_proyecto integer NOT NULL,
    fk_proyecto integer NOT NULL,
    fk_item_trabajo integer NOT NULL
);
 )   DROP TABLE public.item_trabajo_proyecto;
       public         heap    projectmann    false            �            1259    16465 2   item_trabajo_proyecto_id_item_trabajo_proyecto_seq    SEQUENCE     �   CREATE SEQUENCE public.item_trabajo_proyecto_id_item_trabajo_proyecto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 I   DROP SEQUENCE public.item_trabajo_proyecto_id_item_trabajo_proyecto_seq;
       public          projectmann    false    221            J           0    0 2   item_trabajo_proyecto_id_item_trabajo_proyecto_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.item_trabajo_proyecto_id_item_trabajo_proyecto_seq OWNED BY public.item_trabajo_proyecto.id_item_trabajo_proyecto;
          public          projectmann    false    222            �            1259    16467 	   prioridad    TABLE     p   CREATE TABLE public.prioridad (
    id_prioridad smallint NOT NULL,
    nombre character varying(7) NOT NULL
);
    DROP TABLE public.prioridad;
       public         heap    projectmann    false            �            1259    16470    prioridad_id_prioridad_seq    SEQUENCE     �   CREATE SEQUENCE public.prioridad_id_prioridad_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.prioridad_id_prioridad_seq;
       public          projectmann    false    223            K           0    0    prioridad_id_prioridad_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.prioridad_id_prioridad_seq OWNED BY public.prioridad.id_prioridad;
          public          projectmann    false    224            �            1259    16472    proyecto    TABLE     �  CREATE TABLE public.proyecto (
    id_proyecto integer NOT NULL,
    nombre_proyecto character varying(30) NOT NULL,
    fk_estado smallint NOT NULL,
    fk_cliente integer NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_DATE NOT NULL,
    fecha_modificacion timestamp without time zone NOT NULL,
    fk_usuario_modifica integer NOT NULL,
    fk_usuario_crea integer NOT NULL
);
    DROP TABLE public.proyecto;
       public         heap    projectmann    false            �            1259    16476    proyecto_id_proyecto_seq    SEQUENCE     �   CREATE SEQUENCE public.proyecto_id_proyecto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.proyecto_id_proyecto_seq;
       public          projectmann    false    225            L           0    0    proyecto_id_proyecto_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.proyecto_id_proyecto_seq OWNED BY public.proyecto.id_proyecto;
          public          projectmann    false    226            �            1259    16478    rol    TABLE     e   CREATE TABLE public.rol (
    id_rol smallint NOT NULL,
    nombre character varying(50) NOT NULL
);
    DROP TABLE public.rol;
       public         heap    projectmann    false            �            1259    16481    rol_id_rol_seq    SEQUENCE     �   CREATE SEQUENCE public.rol_id_rol_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.rol_id_rol_seq;
       public          projectmann    false    227            M           0    0    rol_id_rol_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.rol_id_rol_seq OWNED BY public.rol.id_rol;
          public          projectmann    false    228            �            1259    16483    ticket    TABLE     �  CREATE TABLE public.ticket (
    id_ticket integer NOT NULL,
    fk_asignado_a integer,
    contenido character varying(1000) NOT NULL,
    fk_prioridad smallint NOT NULL,
    fk_estado smallint NOT NULL,
    fk_tipo_ticket smallint,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_DATE NOT NULL,
    fecha_modificacion timestamp without time zone NOT NULL,
    fk_usuario_modifica integer NOT NULL,
    fk_usuario_crea integer NOT NULL
);
    DROP TABLE public.ticket;
       public         heap    projectmann    false            �            1259    16490    ticket_id_ticket_seq    SEQUENCE     �   CREATE SEQUENCE public.ticket_id_ticket_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.ticket_id_ticket_seq;
       public          projectmann    false    229            N           0    0    ticket_id_ticket_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.ticket_id_ticket_seq OWNED BY public.ticket.id_ticket;
          public          projectmann    false    230            �            1259    16492    tipo_enlace    TABLE     u   CREATE TABLE public.tipo_enlace (
    id_tipo_enlace smallint NOT NULL,
    nombre character varying(15) NOT NULL
);
    DROP TABLE public.tipo_enlace;
       public         heap    projectmann    false            �            1259    16495    tipo_enlace_id_tipo_enlace_seq    SEQUENCE     �   CREATE SEQUENCE public.tipo_enlace_id_tipo_enlace_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.tipo_enlace_id_tipo_enlace_seq;
       public          projectmann    false    231            O           0    0    tipo_enlace_id_tipo_enlace_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.tipo_enlace_id_tipo_enlace_seq OWNED BY public.tipo_enlace.id_tipo_enlace;
          public          projectmann    false    232            �            1259    16497    tipo_identificacion    TABLE     �   CREATE TABLE public.tipo_identificacion (
    id_tipo_identificacion smallint NOT NULL,
    nombre character varying(25) NOT NULL
);
 '   DROP TABLE public.tipo_identificacion;
       public         heap    projectmann    false            �            1259    16500 .   tipo_identificacion_id_tipo_identificacion_seq    SEQUENCE     �   CREATE SEQUENCE public.tipo_identificacion_id_tipo_identificacion_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE public.tipo_identificacion_id_tipo_identificacion_seq;
       public          projectmann    false    233            P           0    0 .   tipo_identificacion_id_tipo_identificacion_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.tipo_identificacion_id_tipo_identificacion_seq OWNED BY public.tipo_identificacion.id_tipo_identificacion;
          public          projectmann    false    234            �            1259    16502    tipo_item_trabajo    TABLE     �   CREATE TABLE public.tipo_item_trabajo (
    id_tipo_item_trabajo smallint NOT NULL,
    nombre character varying(20) NOT NULL
);
 %   DROP TABLE public.tipo_item_trabajo;
       public         heap    projectmann    false            �            1259    16505 *   tipo_item_trabajo_id_tipo_item_trabajo_seq    SEQUENCE     �   CREATE SEQUENCE public.tipo_item_trabajo_id_tipo_item_trabajo_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 A   DROP SEQUENCE public.tipo_item_trabajo_id_tipo_item_trabajo_seq;
       public          projectmann    false    235            Q           0    0 *   tipo_item_trabajo_id_tipo_item_trabajo_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public.tipo_item_trabajo_id_tipo_item_trabajo_seq OWNED BY public.tipo_item_trabajo.id_tipo_item_trabajo;
          public          projectmann    false    236            �            1259    16507    tipo_ticket    TABLE     u   CREATE TABLE public.tipo_ticket (
    id_tipo_ticket smallint NOT NULL,
    nombre character varying(20) NOT NULL
);
    DROP TABLE public.tipo_ticket;
       public         heap    projectmann    false            �            1259    16510    tipo_ticket_id_tipo_ticket_seq    SEQUENCE     �   CREATE SEQUENCE public.tipo_ticket_id_tipo_ticket_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.tipo_ticket_id_tipo_ticket_seq;
       public          projectmann    false    237            R           0    0    tipo_ticket_id_tipo_ticket_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.tipo_ticket_id_tipo_ticket_seq OWNED BY public.tipo_ticket.id_tipo_ticket;
          public          projectmann    false    238            �            1259    16512    usuario_id_usuario_seq    SEQUENCE     �   CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.usuario_id_usuario_seq;
       public          projectmann    false    202            S           0    0    usuario_id_usuario_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;
          public          projectmann    false    239            5           2604    16514    cliente id_cliente    DEFAULT     x   ALTER TABLE ONLY public.cliente ALTER COLUMN id_cliente SET DEFAULT nextval('public.cliente_id_cliente_seq'::regclass);
 A   ALTER TABLE public.cliente ALTER COLUMN id_cliente DROP DEFAULT;
       public          projectmann    false    204    203            7           2604    16515    comentario id_comentario    DEFAULT     �   ALTER TABLE ONLY public.comentario ALTER COLUMN id_comentario SET DEFAULT nextval('public.comentario_id_comentario_seq'::regclass);
 G   ALTER TABLE public.comentario ALTER COLUMN id_comentario DROP DEFAULT;
       public          projectmann    false    206    205            8           2604    16516 2   comentario_item_trabajo id_comentario_item_trabajo    DEFAULT     �   ALTER TABLE ONLY public.comentario_item_trabajo ALTER COLUMN id_comentario_item_trabajo SET DEFAULT nextval('public.comentario_item_trabajo_id_comentario_item_trabajo_seq'::regclass);
 a   ALTER TABLE public.comentario_item_trabajo ALTER COLUMN id_comentario_item_trabajo DROP DEFAULT;
       public          projectmann    false    208    207            9           2604    16517 *   comentario_proyecto id_comentario_proyecto    DEFAULT     �   ALTER TABLE ONLY public.comentario_proyecto ALTER COLUMN id_comentario_proyecto SET DEFAULT nextval('public.comentario_proyecto_id_comentario_proyecto_seq'::regclass);
 Y   ALTER TABLE public.comentario_proyecto ALTER COLUMN id_comentario_proyecto DROP DEFAULT;
       public          projectmann    false    210    209            :           2604    16518 &   comentario_ticket id_comentario_ticket    DEFAULT     �   ALTER TABLE ONLY public.comentario_ticket ALTER COLUMN id_comentario_ticket SET DEFAULT nextval('public.comentario_ticket_id_comentario_ticket_seq'::regclass);
 U   ALTER TABLE public.comentario_ticket ALTER COLUMN id_comentario_ticket DROP DEFAULT;
       public          projectmann    false    212    211            ;           2604    16519    estado id_estado    DEFAULT     t   ALTER TABLE ONLY public.estado ALTER COLUMN id_estado SET DEFAULT nextval('public.estado_id_estado_seq'::regclass);
 ?   ALTER TABLE public.estado ALTER COLUMN id_estado DROP DEFAULT;
       public          projectmann    false    214    213            =           2604    16520 "   item_inventario id_item_inventario    DEFAULT     �   ALTER TABLE ONLY public.item_inventario ALTER COLUMN id_item_inventario SET DEFAULT nextval('public.item_inventario_id_item_inventario_seq'::regclass);
 Q   ALTER TABLE public.item_inventario ALTER COLUMN id_item_inventario DROP DEFAULT;
       public          projectmann    false    216    215            ?           2604    16521    item_trabajo id_item_trabajo    DEFAULT     �   ALTER TABLE ONLY public.item_trabajo ALTER COLUMN id_item_trabajo SET DEFAULT nextval('public.item_trabajo_id_item_trabajo_seq'::regclass);
 K   ALTER TABLE public.item_trabajo ALTER COLUMN id_item_trabajo DROP DEFAULT;
       public          projectmann    false    220    217            @           2604    16522 *   item_trabajo_enlace id_item_trabajo_enlace    DEFAULT     �   ALTER TABLE ONLY public.item_trabajo_enlace ALTER COLUMN id_item_trabajo_enlace SET DEFAULT nextval('public.item_trabajo_enlace_id_item_trabajo_enlace_seq'::regclass);
 Y   ALTER TABLE public.item_trabajo_enlace ALTER COLUMN id_item_trabajo_enlace DROP DEFAULT;
       public          projectmann    false    219    218            A           2604    16523 .   item_trabajo_proyecto id_item_trabajo_proyecto    DEFAULT     �   ALTER TABLE ONLY public.item_trabajo_proyecto ALTER COLUMN id_item_trabajo_proyecto SET DEFAULT nextval('public.item_trabajo_proyecto_id_item_trabajo_proyecto_seq'::regclass);
 ]   ALTER TABLE public.item_trabajo_proyecto ALTER COLUMN id_item_trabajo_proyecto DROP DEFAULT;
       public          projectmann    false    222    221            B           2604    16524    prioridad id_prioridad    DEFAULT     �   ALTER TABLE ONLY public.prioridad ALTER COLUMN id_prioridad SET DEFAULT nextval('public.prioridad_id_prioridad_seq'::regclass);
 E   ALTER TABLE public.prioridad ALTER COLUMN id_prioridad DROP DEFAULT;
       public          projectmann    false    224    223            D           2604    16525    proyecto id_proyecto    DEFAULT     |   ALTER TABLE ONLY public.proyecto ALTER COLUMN id_proyecto SET DEFAULT nextval('public.proyecto_id_proyecto_seq'::regclass);
 C   ALTER TABLE public.proyecto ALTER COLUMN id_proyecto DROP DEFAULT;
       public          projectmann    false    226    225            E           2604    16526 
   rol id_rol    DEFAULT     h   ALTER TABLE ONLY public.rol ALTER COLUMN id_rol SET DEFAULT nextval('public.rol_id_rol_seq'::regclass);
 9   ALTER TABLE public.rol ALTER COLUMN id_rol DROP DEFAULT;
       public          projectmann    false    228    227            G           2604    16527    ticket id_ticket    DEFAULT     t   ALTER TABLE ONLY public.ticket ALTER COLUMN id_ticket SET DEFAULT nextval('public.ticket_id_ticket_seq'::regclass);
 ?   ALTER TABLE public.ticket ALTER COLUMN id_ticket DROP DEFAULT;
       public          projectmann    false    230    229            H           2604    16528    tipo_enlace id_tipo_enlace    DEFAULT     �   ALTER TABLE ONLY public.tipo_enlace ALTER COLUMN id_tipo_enlace SET DEFAULT nextval('public.tipo_enlace_id_tipo_enlace_seq'::regclass);
 I   ALTER TABLE public.tipo_enlace ALTER COLUMN id_tipo_enlace DROP DEFAULT;
       public          projectmann    false    232    231            I           2604    16529 *   tipo_identificacion id_tipo_identificacion    DEFAULT     �   ALTER TABLE ONLY public.tipo_identificacion ALTER COLUMN id_tipo_identificacion SET DEFAULT nextval('public.tipo_identificacion_id_tipo_identificacion_seq'::regclass);
 Y   ALTER TABLE public.tipo_identificacion ALTER COLUMN id_tipo_identificacion DROP DEFAULT;
       public          projectmann    false    234    233            J           2604    16530 &   tipo_item_trabajo id_tipo_item_trabajo    DEFAULT     �   ALTER TABLE ONLY public.tipo_item_trabajo ALTER COLUMN id_tipo_item_trabajo SET DEFAULT nextval('public.tipo_item_trabajo_id_tipo_item_trabajo_seq'::regclass);
 U   ALTER TABLE public.tipo_item_trabajo ALTER COLUMN id_tipo_item_trabajo DROP DEFAULT;
       public          projectmann    false    236    235            K           2604    16531    tipo_ticket id_tipo_ticket    DEFAULT     �   ALTER TABLE ONLY public.tipo_ticket ALTER COLUMN id_tipo_ticket SET DEFAULT nextval('public.tipo_ticket_id_tipo_ticket_seq'::regclass);
 I   ALTER TABLE public.tipo_ticket ALTER COLUMN id_tipo_ticket DROP DEFAULT;
       public          projectmann    false    238    237            3           2604    16532    usuario id_usuario    DEFAULT     x   ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);
 A   ALTER TABLE public.usuario ALTER COLUMN id_usuario DROP DEFAULT;
       public          projectmann    false    239    202                      0    16404    cliente 
   TABLE DATA           �   COPY public.cliente (id_cliente, nombre, telefono, celular, email, fk_tipo_identificacion, identificacion, fecha_creacion, fecha_modificacion, fk_usuario_modifica, fk_usuario_crea) FROM stdin;
    public          projectmann    false    203   ��                 0    16410 
   comentario 
   TABLE DATA           �   COPY public.comentario (id_comentario, contenido, fecha_creacion, fecha_modificacion, fk_usuario_modifica, fk_usuario_crea) FROM stdin;
    public          projectmann    false    205   o                0    16419    comentario_item_trabajo 
   TABLE DATA           m   COPY public.comentario_item_trabajo (id_comentario_item_trabajo, fk_comentario, fk_item_trabajo) FROM stdin;
    public          projectmann    false    207   �                0    16424    comentario_proyecto 
   TABLE DATA           a   COPY public.comentario_proyecto (id_comentario_proyecto, fk_comentario, fk_proyecto) FROM stdin;
    public          projectmann    false    209   �                0    16429    comentario_ticket 
   TABLE DATA           [   COPY public.comentario_ticket (id_comentario_ticket, fk_comentario, fk_ticket) FROM stdin;
    public          projectmann    false    211   �                 0    16434    estado 
   TABLE DATA           3   COPY public.estado (id_estado, nombre) FROM stdin;
    public          projectmann    false    213   �      "          0    16439    item_inventario 
   TABLE DATA           �   COPY public.item_inventario (id_item_inventario, fk_asignado_a, nombre_software, licencia, version, fecha_creacion, fecha_modificacion, fk_usuario_modifica, fk_usuario_crea) FROM stdin;
    public          projectmann    false    215   D      $          0    16448    item_trabajo 
   TABLE DATA           �   COPY public.item_trabajo (id_item_trabajo, fk_tipo_item_trabajo, titulo, descripcion, fk_estado, fk_asignado_a, fecha_creacion, fecha_modificacion, fk_usuario_modifica, fk_usuario_crea) FROM stdin;
    public          projectmann    false    217         %          0    16455    item_trabajo_enlace 
   TABLE DATA           {   COPY public.item_trabajo_enlace (id_item_trabajo_enlace, fk_item_trabajo_1, fk_item_trabajo_2, fk_tipo_enlace) FROM stdin;
    public          projectmann    false    218   �      (          0    16462    item_trabajo_proyecto 
   TABLE DATA           g   COPY public.item_trabajo_proyecto (id_item_trabajo_proyecto, fk_proyecto, fk_item_trabajo) FROM stdin;
    public          projectmann    false    221   �      *          0    16467 	   prioridad 
   TABLE DATA           9   COPY public.prioridad (id_prioridad, nombre) FROM stdin;
    public          projectmann    false    223   �      ,          0    16472    proyecto 
   TABLE DATA           �   COPY public.proyecto (id_proyecto, nombre_proyecto, fk_estado, fk_cliente, fecha_creacion, fecha_modificacion, fk_usuario_modifica, fk_usuario_crea) FROM stdin;
    public          projectmann    false    225   	      .          0    16478    rol 
   TABLE DATA           -   COPY public.rol (id_rol, nombre) FROM stdin;
    public          projectmann    false    227   :      0          0    16483    ticket 
   TABLE DATA           �   COPY public.ticket (id_ticket, fk_asignado_a, contenido, fk_prioridad, fk_estado, fk_tipo_ticket, fecha_creacion, fecha_modificacion, fk_usuario_modifica, fk_usuario_crea) FROM stdin;
    public          projectmann    false    229   }      2          0    16492    tipo_enlace 
   TABLE DATA           =   COPY public.tipo_enlace (id_tipo_enlace, nombre) FROM stdin;
    public          projectmann    false    231   �      4          0    16497    tipo_identificacion 
   TABLE DATA           M   COPY public.tipo_identificacion (id_tipo_identificacion, nombre) FROM stdin;
    public          projectmann    false    233   �      6          0    16502    tipo_item_trabajo 
   TABLE DATA           I   COPY public.tipo_item_trabajo (id_tipo_item_trabajo, nombre) FROM stdin;
    public          projectmann    false    235         8          0    16507    tipo_ticket 
   TABLE DATA           =   COPY public.tipo_ticket (id_tipo_ticket, nombre) FROM stdin;
    public          projectmann    false    237   |                0    16396    usuario 
   TABLE DATA           �   COPY public.usuario (id_usuario, nombre, apellido, clave, fk_rol, nombre_usuario, email, estado, fecha_creacion, fecha_modificacion, fk_usuario_modifica, fk_usuario_crea) FROM stdin;
    public          projectmann    false    202   �      T           0    0    cliente_id_cliente_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.cliente_id_cliente_seq', 71, true);
          public          projectmann    false    204            U           0    0    comentario_id_comentario_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.comentario_id_comentario_seq', 3, true);
          public          projectmann    false    206            V           0    0 6   comentario_item_trabajo_id_comentario_item_trabajo_seq    SEQUENCE SET     d   SELECT pg_catalog.setval('public.comentario_item_trabajo_id_comentario_item_trabajo_seq', 3, true);
          public          projectmann    false    208            W           0    0 .   comentario_proyecto_id_comentario_proyecto_seq    SEQUENCE SET     \   SELECT pg_catalog.setval('public.comentario_proyecto_id_comentario_proyecto_seq', 6, true);
          public          projectmann    false    210            X           0    0 *   comentario_ticket_id_comentario_ticket_seq    SEQUENCE SET     X   SELECT pg_catalog.setval('public.comentario_ticket_id_comentario_ticket_seq', 6, true);
          public          projectmann    false    212            Y           0    0    estado_id_estado_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.estado_id_estado_seq', 7, true);
          public          projectmann    false    214            Z           0    0 &   item_inventario_id_item_inventario_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public.item_inventario_id_item_inventario_seq', 89, true);
          public          projectmann    false    216            [           0    0 .   item_trabajo_enlace_id_item_trabajo_enlace_seq    SEQUENCE SET     \   SELECT pg_catalog.setval('public.item_trabajo_enlace_id_item_trabajo_enlace_seq', 3, true);
          public          projectmann    false    219            \           0    0     item_trabajo_id_item_trabajo_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.item_trabajo_id_item_trabajo_seq', 22, true);
          public          projectmann    false    220            ]           0    0 2   item_trabajo_proyecto_id_item_trabajo_proyecto_seq    SEQUENCE SET     a   SELECT pg_catalog.setval('public.item_trabajo_proyecto_id_item_trabajo_proyecto_seq', 14, true);
          public          projectmann    false    222            ^           0    0    prioridad_id_prioridad_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.prioridad_id_prioridad_seq', 3, true);
          public          projectmann    false    224            _           0    0    proyecto_id_proyecto_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.proyecto_id_proyecto_seq', 22, true);
          public          projectmann    false    226            `           0    0    rol_id_rol_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.rol_id_rol_seq', 3, true);
          public          projectmann    false    228            a           0    0    ticket_id_ticket_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.ticket_id_ticket_seq', 17, true);
          public          projectmann    false    230            b           0    0    tipo_enlace_id_tipo_enlace_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.tipo_enlace_id_tipo_enlace_seq', 3, true);
          public          projectmann    false    232            c           0    0 .   tipo_identificacion_id_tipo_identificacion_seq    SEQUENCE SET     \   SELECT pg_catalog.setval('public.tipo_identificacion_id_tipo_identificacion_seq', 5, true);
          public          projectmann    false    234            d           0    0 *   tipo_item_trabajo_id_tipo_item_trabajo_seq    SEQUENCE SET     X   SELECT pg_catalog.setval('public.tipo_item_trabajo_id_tipo_item_trabajo_seq', 5, true);
          public          projectmann    false    236            e           0    0    tipo_ticket_id_tipo_ticket_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.tipo_ticket_id_tipo_ticket_seq', 3, true);
          public          projectmann    false    238            f           0    0    usuario_id_usuario_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 17, true);
          public          projectmann    false    239            O           2606    16534    cliente cliente_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cliente);
 >   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
       public            projectmann    false    203            S           2606    16536 4   comentario_item_trabajo comentario_item_trabajo_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.comentario_item_trabajo
    ADD CONSTRAINT comentario_item_trabajo_pkey PRIMARY KEY (id_comentario_item_trabajo);
 ^   ALTER TABLE ONLY public.comentario_item_trabajo DROP CONSTRAINT comentario_item_trabajo_pkey;
       public            projectmann    false    207            Q           2606    16538    comentario comentario_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT comentario_pkey PRIMARY KEY (id_comentario);
 D   ALTER TABLE ONLY public.comentario DROP CONSTRAINT comentario_pkey;
       public            projectmann    false    205            U           2606    16540 ,   comentario_proyecto comentario_proyecto_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.comentario_proyecto
    ADD CONSTRAINT comentario_proyecto_pkey PRIMARY KEY (id_comentario_proyecto);
 V   ALTER TABLE ONLY public.comentario_proyecto DROP CONSTRAINT comentario_proyecto_pkey;
       public            projectmann    false    209            W           2606    16542 (   comentario_ticket comentario_ticket_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.comentario_ticket
    ADD CONSTRAINT comentario_ticket_pkey PRIMARY KEY (id_comentario_ticket);
 R   ALTER TABLE ONLY public.comentario_ticket DROP CONSTRAINT comentario_ticket_pkey;
       public            projectmann    false    211            Y           2606    16544    estado estado_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.estado
    ADD CONSTRAINT estado_pkey PRIMARY KEY (id_estado);
 <   ALTER TABLE ONLY public.estado DROP CONSTRAINT estado_pkey;
       public            projectmann    false    213            [           2606    16546 $   item_inventario item_inventario_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.item_inventario
    ADD CONSTRAINT item_inventario_pkey PRIMARY KEY (id_item_inventario);
 N   ALTER TABLE ONLY public.item_inventario DROP CONSTRAINT item_inventario_pkey;
       public            projectmann    false    215            _           2606    16548 ,   item_trabajo_enlace item_trabajo_enlace_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.item_trabajo_enlace
    ADD CONSTRAINT item_trabajo_enlace_pkey PRIMARY KEY (id_item_trabajo_enlace);
 V   ALTER TABLE ONLY public.item_trabajo_enlace DROP CONSTRAINT item_trabajo_enlace_pkey;
       public            projectmann    false    218            ]           2606    16550    item_trabajo item_trabajo_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.item_trabajo
    ADD CONSTRAINT item_trabajo_pkey PRIMARY KEY (id_item_trabajo);
 H   ALTER TABLE ONLY public.item_trabajo DROP CONSTRAINT item_trabajo_pkey;
       public            projectmann    false    217            a           2606    16552 0   item_trabajo_proyecto item_trabajo_proyecto_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.item_trabajo_proyecto
    ADD CONSTRAINT item_trabajo_proyecto_pkey PRIMARY KEY (id_item_trabajo_proyecto);
 Z   ALTER TABLE ONLY public.item_trabajo_proyecto DROP CONSTRAINT item_trabajo_proyecto_pkey;
       public            projectmann    false    221            c           2606    16554    prioridad prioridad_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.prioridad
    ADD CONSTRAINT prioridad_pkey PRIMARY KEY (id_prioridad);
 B   ALTER TABLE ONLY public.prioridad DROP CONSTRAINT prioridad_pkey;
       public            projectmann    false    223            e           2606    16556    proyecto proyecto_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.proyecto
    ADD CONSTRAINT proyecto_pkey PRIMARY KEY (id_proyecto);
 @   ALTER TABLE ONLY public.proyecto DROP CONSTRAINT proyecto_pkey;
       public            projectmann    false    225            g           2606    16558    rol rol_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id_rol);
 6   ALTER TABLE ONLY public.rol DROP CONSTRAINT rol_pkey;
       public            projectmann    false    227            i           2606    16560    ticket ticket_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (id_ticket);
 <   ALTER TABLE ONLY public.ticket DROP CONSTRAINT ticket_pkey;
       public            projectmann    false    229            k           2606    16562    tipo_enlace tipo_enlace_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.tipo_enlace
    ADD CONSTRAINT tipo_enlace_pkey PRIMARY KEY (id_tipo_enlace);
 F   ALTER TABLE ONLY public.tipo_enlace DROP CONSTRAINT tipo_enlace_pkey;
       public            projectmann    false    231            m           2606    16564 ,   tipo_identificacion tipo_identificacion_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.tipo_identificacion
    ADD CONSTRAINT tipo_identificacion_pkey PRIMARY KEY (id_tipo_identificacion);
 V   ALTER TABLE ONLY public.tipo_identificacion DROP CONSTRAINT tipo_identificacion_pkey;
       public            projectmann    false    233            o           2606    16566 (   tipo_item_trabajo tipo_item_trabajo_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.tipo_item_trabajo
    ADD CONSTRAINT tipo_item_trabajo_pkey PRIMARY KEY (id_tipo_item_trabajo);
 R   ALTER TABLE ONLY public.tipo_item_trabajo DROP CONSTRAINT tipo_item_trabajo_pkey;
       public            projectmann    false    235            q           2606    16568    tipo_ticket tipo_ticket_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.tipo_ticket
    ADD CONSTRAINT tipo_ticket_pkey PRIMARY KEY (id_tipo_ticket);
 F   ALTER TABLE ONLY public.tipo_ticket DROP CONSTRAINT tipo_ticket_pkey;
       public            projectmann    false    237            M           2606    16570    usuario usuario_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public            projectmann    false    202            u           2606    16571 +   cliente cliente_fk_tipo_identificacion_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_fk_tipo_identificacion_fkey FOREIGN KEY (fk_tipo_identificacion) REFERENCES public.tipo_identificacion(id_tipo_identificacion);
 U   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_fk_tipo_identificacion_fkey;
       public          projectmann    false    3181    203    233            v           2606    16576 $   cliente cliente_fk_usuario_crea_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_fk_usuario_crea_fkey FOREIGN KEY (fk_usuario_crea) REFERENCES public.usuario(id_usuario);
 N   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_fk_usuario_crea_fkey;
       public          projectmann    false    202    203    3149            w           2606    16581 (   cliente cliente_fk_usuario_modifica_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_fk_usuario_modifica_fkey FOREIGN KEY (fk_usuario_modifica) REFERENCES public.usuario(id_usuario);
 R   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_fk_usuario_modifica_fkey;
       public          projectmann    false    203    202    3149            x           2606    16586 *   comentario comentario_fk_usuario_crea_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT comentario_fk_usuario_crea_fkey FOREIGN KEY (fk_usuario_crea) REFERENCES public.usuario(id_usuario);
 T   ALTER TABLE ONLY public.comentario DROP CONSTRAINT comentario_fk_usuario_crea_fkey;
       public          projectmann    false    3149    202    205            y           2606    16591 .   comentario comentario_fk_usuario_modifica_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT comentario_fk_usuario_modifica_fkey FOREIGN KEY (fk_usuario_modifica) REFERENCES public.usuario(id_usuario);
 X   ALTER TABLE ONLY public.comentario DROP CONSTRAINT comentario_fk_usuario_modifica_fkey;
       public          projectmann    false    205    3149    202            z           2606    16596 B   comentario_item_trabajo comentario_item_trabajo_fk_comentario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comentario_item_trabajo
    ADD CONSTRAINT comentario_item_trabajo_fk_comentario_fkey FOREIGN KEY (fk_comentario) REFERENCES public.comentario(id_comentario);
 l   ALTER TABLE ONLY public.comentario_item_trabajo DROP CONSTRAINT comentario_item_trabajo_fk_comentario_fkey;
       public          projectmann    false    207    205    3153            {           2606    16601 D   comentario_item_trabajo comentario_item_trabajo_fk_item_trabajo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comentario_item_trabajo
    ADD CONSTRAINT comentario_item_trabajo_fk_item_trabajo_fkey FOREIGN KEY (fk_item_trabajo) REFERENCES public.item_trabajo(id_item_trabajo);
 n   ALTER TABLE ONLY public.comentario_item_trabajo DROP CONSTRAINT comentario_item_trabajo_fk_item_trabajo_fkey;
       public          projectmann    false    217    3165    207            |           2606    16606 :   comentario_proyecto comentario_proyecto_fk_comentario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comentario_proyecto
    ADD CONSTRAINT comentario_proyecto_fk_comentario_fkey FOREIGN KEY (fk_comentario) REFERENCES public.comentario(id_comentario);
 d   ALTER TABLE ONLY public.comentario_proyecto DROP CONSTRAINT comentario_proyecto_fk_comentario_fkey;
       public          projectmann    false    209    205    3153            }           2606    16611 8   comentario_proyecto comentario_proyecto_fk_proyecto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comentario_proyecto
    ADD CONSTRAINT comentario_proyecto_fk_proyecto_fkey FOREIGN KEY (fk_proyecto) REFERENCES public.proyecto(id_proyecto);
 b   ALTER TABLE ONLY public.comentario_proyecto DROP CONSTRAINT comentario_proyecto_fk_proyecto_fkey;
       public          projectmann    false    209    225    3173            ~           2606    16616 6   comentario_ticket comentario_ticket_fk_comentario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comentario_ticket
    ADD CONSTRAINT comentario_ticket_fk_comentario_fkey FOREIGN KEY (fk_comentario) REFERENCES public.comentario(id_comentario);
 `   ALTER TABLE ONLY public.comentario_ticket DROP CONSTRAINT comentario_ticket_fk_comentario_fkey;
       public          projectmann    false    3153    205    211                       2606    16621 2   comentario_ticket comentario_ticket_fk_ticket_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comentario_ticket
    ADD CONSTRAINT comentario_ticket_fk_ticket_fkey FOREIGN KEY (fk_ticket) REFERENCES public.ticket(id_ticket);
 \   ALTER TABLE ONLY public.comentario_ticket DROP CONSTRAINT comentario_ticket_fk_ticket_fkey;
       public          projectmann    false    211    3177    229            �           2606    16626 2   item_inventario item_inventario_fk_asignado_a_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_inventario
    ADD CONSTRAINT item_inventario_fk_asignado_a_fkey FOREIGN KEY (fk_asignado_a) REFERENCES public.usuario(id_usuario);
 \   ALTER TABLE ONLY public.item_inventario DROP CONSTRAINT item_inventario_fk_asignado_a_fkey;
       public          projectmann    false    3149    215    202            �           2606    16631 4   item_inventario item_inventario_fk_usuario_crea_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_inventario
    ADD CONSTRAINT item_inventario_fk_usuario_crea_fkey FOREIGN KEY (fk_usuario_crea) REFERENCES public.usuario(id_usuario);
 ^   ALTER TABLE ONLY public.item_inventario DROP CONSTRAINT item_inventario_fk_usuario_crea_fkey;
       public          projectmann    false    202    3149    215            �           2606    16636 8   item_inventario item_inventario_fk_usuario_modifica_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_inventario
    ADD CONSTRAINT item_inventario_fk_usuario_modifica_fkey FOREIGN KEY (fk_usuario_modifica) REFERENCES public.usuario(id_usuario);
 b   ALTER TABLE ONLY public.item_inventario DROP CONSTRAINT item_inventario_fk_usuario_modifica_fkey;
       public          projectmann    false    3149    202    215            �           2606    16641 >   item_trabajo_enlace item_trabajo_enlace_fk_item_trabajo_1_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_trabajo_enlace
    ADD CONSTRAINT item_trabajo_enlace_fk_item_trabajo_1_fkey FOREIGN KEY (fk_item_trabajo_1) REFERENCES public.item_trabajo(id_item_trabajo);
 h   ALTER TABLE ONLY public.item_trabajo_enlace DROP CONSTRAINT item_trabajo_enlace_fk_item_trabajo_1_fkey;
       public          projectmann    false    217    218    3165            �           2606    16646 >   item_trabajo_enlace item_trabajo_enlace_fk_item_trabajo_2_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_trabajo_enlace
    ADD CONSTRAINT item_trabajo_enlace_fk_item_trabajo_2_fkey FOREIGN KEY (fk_item_trabajo_2) REFERENCES public.item_trabajo(id_item_trabajo);
 h   ALTER TABLE ONLY public.item_trabajo_enlace DROP CONSTRAINT item_trabajo_enlace_fk_item_trabajo_2_fkey;
       public          projectmann    false    217    218    3165            �           2606    16651 ;   item_trabajo_enlace item_trabajo_enlace_fk_tipo_enlace_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_trabajo_enlace
    ADD CONSTRAINT item_trabajo_enlace_fk_tipo_enlace_fkey FOREIGN KEY (fk_tipo_enlace) REFERENCES public.tipo_enlace(id_tipo_enlace);
 e   ALTER TABLE ONLY public.item_trabajo_enlace DROP CONSTRAINT item_trabajo_enlace_fk_tipo_enlace_fkey;
       public          projectmann    false    218    231    3179            �           2606    16656 ,   item_trabajo item_trabajo_fk_asignado_a_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_trabajo
    ADD CONSTRAINT item_trabajo_fk_asignado_a_fkey FOREIGN KEY (fk_asignado_a) REFERENCES public.usuario(id_usuario);
 V   ALTER TABLE ONLY public.item_trabajo DROP CONSTRAINT item_trabajo_fk_asignado_a_fkey;
       public          projectmann    false    217    202    3149            �           2606    16661 (   item_trabajo item_trabajo_fk_estado_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_trabajo
    ADD CONSTRAINT item_trabajo_fk_estado_fkey FOREIGN KEY (fk_estado) REFERENCES public.estado(id_estado);
 R   ALTER TABLE ONLY public.item_trabajo DROP CONSTRAINT item_trabajo_fk_estado_fkey;
       public          projectmann    false    3161    217    213            �           2606    16666 3   item_trabajo item_trabajo_fk_tipo_item_trabajo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_trabajo
    ADD CONSTRAINT item_trabajo_fk_tipo_item_trabajo_fkey FOREIGN KEY (fk_tipo_item_trabajo) REFERENCES public.tipo_item_trabajo(id_tipo_item_trabajo);
 ]   ALTER TABLE ONLY public.item_trabajo DROP CONSTRAINT item_trabajo_fk_tipo_item_trabajo_fkey;
       public          projectmann    false    3183    235    217            �           2606    16671 .   item_trabajo item_trabajo_fk_usuario_crea_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_trabajo
    ADD CONSTRAINT item_trabajo_fk_usuario_crea_fkey FOREIGN KEY (fk_usuario_crea) REFERENCES public.usuario(id_usuario);
 X   ALTER TABLE ONLY public.item_trabajo DROP CONSTRAINT item_trabajo_fk_usuario_crea_fkey;
       public          projectmann    false    202    3149    217            �           2606    16676 2   item_trabajo item_trabajo_fk_usuario_modifica_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_trabajo
    ADD CONSTRAINT item_trabajo_fk_usuario_modifica_fkey FOREIGN KEY (fk_usuario_modifica) REFERENCES public.usuario(id_usuario);
 \   ALTER TABLE ONLY public.item_trabajo DROP CONSTRAINT item_trabajo_fk_usuario_modifica_fkey;
       public          projectmann    false    202    3149    217            �           2606    16681 @   item_trabajo_proyecto item_trabajo_proyecto_fk_item_trabajo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_trabajo_proyecto
    ADD CONSTRAINT item_trabajo_proyecto_fk_item_trabajo_fkey FOREIGN KEY (fk_item_trabajo) REFERENCES public.item_trabajo(id_item_trabajo);
 j   ALTER TABLE ONLY public.item_trabajo_proyecto DROP CONSTRAINT item_trabajo_proyecto_fk_item_trabajo_fkey;
       public          projectmann    false    3165    217    221            �           2606    16686 <   item_trabajo_proyecto item_trabajo_proyecto_fk_proyecto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_trabajo_proyecto
    ADD CONSTRAINT item_trabajo_proyecto_fk_proyecto_fkey FOREIGN KEY (fk_proyecto) REFERENCES public.proyecto(id_proyecto);
 f   ALTER TABLE ONLY public.item_trabajo_proyecto DROP CONSTRAINT item_trabajo_proyecto_fk_proyecto_fkey;
       public          projectmann    false    225    221    3173            �           2606    16691 !   proyecto proyecto_fk_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.proyecto
    ADD CONSTRAINT proyecto_fk_cliente_fkey FOREIGN KEY (fk_cliente) REFERENCES public.cliente(id_cliente);
 K   ALTER TABLE ONLY public.proyecto DROP CONSTRAINT proyecto_fk_cliente_fkey;
       public          projectmann    false    225    203    3151            �           2606    16696     proyecto proyecto_fk_estado_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.proyecto
    ADD CONSTRAINT proyecto_fk_estado_fkey FOREIGN KEY (fk_estado) REFERENCES public.estado(id_estado);
 J   ALTER TABLE ONLY public.proyecto DROP CONSTRAINT proyecto_fk_estado_fkey;
       public          projectmann    false    3161    213    225            �           2606    16701 &   proyecto proyecto_fk_usuario_crea_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.proyecto
    ADD CONSTRAINT proyecto_fk_usuario_crea_fkey FOREIGN KEY (fk_usuario_crea) REFERENCES public.usuario(id_usuario);
 P   ALTER TABLE ONLY public.proyecto DROP CONSTRAINT proyecto_fk_usuario_crea_fkey;
       public          projectmann    false    202    3149    225            �           2606    16706 *   proyecto proyecto_fk_usuario_modifica_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.proyecto
    ADD CONSTRAINT proyecto_fk_usuario_modifica_fkey FOREIGN KEY (fk_usuario_modifica) REFERENCES public.usuario(id_usuario);
 T   ALTER TABLE ONLY public.proyecto DROP CONSTRAINT proyecto_fk_usuario_modifica_fkey;
       public          projectmann    false    3149    225    202            �           2606    16711     ticket ticket_fk_asignado_a_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_fk_asignado_a_fkey FOREIGN KEY (fk_asignado_a) REFERENCES public.usuario(id_usuario);
 J   ALTER TABLE ONLY public.ticket DROP CONSTRAINT ticket_fk_asignado_a_fkey;
       public          projectmann    false    3149    202    229            �           2606    16716    ticket ticket_fk_estado_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_fk_estado_fkey FOREIGN KEY (fk_estado) REFERENCES public.estado(id_estado);
 F   ALTER TABLE ONLY public.ticket DROP CONSTRAINT ticket_fk_estado_fkey;
       public          projectmann    false    3161    213    229            �           2606    16721    ticket ticket_fk_prioridad_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_fk_prioridad_fkey FOREIGN KEY (fk_prioridad) REFERENCES public.prioridad(id_prioridad);
 I   ALTER TABLE ONLY public.ticket DROP CONSTRAINT ticket_fk_prioridad_fkey;
       public          projectmann    false    223    229    3171            �           2606    16726 !   ticket ticket_fk_tipo_ticket_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_fk_tipo_ticket_fkey FOREIGN KEY (fk_tipo_ticket) REFERENCES public.tipo_ticket(id_tipo_ticket);
 K   ALTER TABLE ONLY public.ticket DROP CONSTRAINT ticket_fk_tipo_ticket_fkey;
       public          projectmann    false    3185    229    237            �           2606    16731 "   ticket ticket_fk_usuario_crea_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_fk_usuario_crea_fkey FOREIGN KEY (fk_usuario_crea) REFERENCES public.usuario(id_usuario);
 L   ALTER TABLE ONLY public.ticket DROP CONSTRAINT ticket_fk_usuario_crea_fkey;
       public          projectmann    false    3149    229    202            �           2606    16736 &   ticket ticket_fk_usuario_modifica_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_fk_usuario_modifica_fkey FOREIGN KEY (fk_usuario_modifica) REFERENCES public.usuario(id_usuario);
 P   ALTER TABLE ONLY public.ticket DROP CONSTRAINT ticket_fk_usuario_modifica_fkey;
       public          projectmann    false    3149    229    202            r           2606    16741    usuario usuario_fk_rol_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_fk_rol_fkey FOREIGN KEY (fk_rol) REFERENCES public.rol(id_rol);
 E   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_fk_rol_fkey;
       public          projectmann    false    227    202    3175            s           2606    16746 $   usuario usuario_fk_usuario_crea_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_fk_usuario_crea_fkey FOREIGN KEY (fk_usuario_crea) REFERENCES public.usuario(id_usuario);
 N   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_fk_usuario_crea_fkey;
       public          projectmann    false    3149    202    202            t           2606    16751 (   usuario usuario_fk_usuario_modifica_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_fk_usuario_modifica_fkey FOREIGN KEY (fk_usuario_modifica) REFERENCES public.usuario(id_usuario);
 R   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_fk_usuario_modifica_fkey;
       public          projectmann    false    202    3149    202               z  x��XM��<�~����D�46$���1|�6�g���R��>�\RrnAK�إ���W��#�1����D�tTK�Z����n�C�.~�~�/'�R+�Q�p��w�|��[J��_������0A~�eY�@��)E��a���!�[��F���%�R��x��Br���o ��~G�;&w�
#�"���_��O_�fV2'�P�	�)��}��ĺ%�!��p�c2���2j�1-����!�����\K���|L�r�]?��Kk��3i[�4��D��LT��ph���4���g/�r�R-US]���kHD�5$��3ܑ)����x�
<KI�@Y�}�S�JP#P��J��O�����D��C��4G>�?�r"N�)Jx�G>�Tf����q�CF'�Lh�k � f�`׈/i]4P�>�R2MaY����a��iF���d���)�ǀFZ��(�Q�+��80�vK��KdaZ:c�-=����=Q�*-):*�b��'���y+/Ë?�g[CA��[*���	S��!�K�<g�aJ�C�����4U<��RZNa
��c�bx�&L	Y��T0&�,�w��愰dJא��w���ã��vN����<�.���ZtO�9HK-�#s�2tC��Zv�tE�`DA0�"2\�_�q�ˉ��>�8(*�������X�]LX��
/�hȿ���� �o#S
N �xZ�q9�(ft�)���?Oi��%��u�e!�����cĊ����s8teȱ�?4�'�gt���F�sP/���.�d<�qLs8v�Q�:�U�j�V٢���O�8�C&FA�%���:�|>���S�.�/��_���
X�j�L沄|�9���k$���sl�ӆ��/eL�C�a�B��a�1�tN~�>�X�0V�5t0˩��䲠�>�?w9������I��j� ?!(�= �V�'��YC���4ù+��E~:�� X�۲0P����ĿE4T�p�a7�p�W���MK<l_}S!�I�d�zվ}:n�@�Q��p3��s��)�a�n�Gk!QNP�ES����郟	\�b_P#R�q
1#�V�m�.��N�qT`�M�4�[��9ęJ����4��q.��|��<�%���(�T�%�ƫ'��!=N��3I�U*�n�8Dl�cM,�m!��	Б�~y������!wȣ�Z��1���=�룫�QM9Yු�1��?�8��
�v];N������
X*�4���0!t�<"�V�ep���8���K�92P���о����R\5t������ea]� ��b;�� !N��U��]m�<FWz��JQ}z�_�@4ռ�>����Đ�n�	wz�;��pCm[��*]\W���\����|��:��n9D���8��N��m���U�EC�,�h,+����7����Eڰ�(�Vm�O��Y`�`�(��p�R����
�s���$-i���0�=�����zdIFk!��3��!3_w�V)�E&���WC��
�pJR�q(k%i��c)/��é^v)��3��wRKΒ�)��THz�WV#aͥ����.Ms���M~��D��+��5�G�+� �L�׵PxX_��K	3c��?B��� ��&U��m�����2�Ё����<�aH�¸1��!����V�CԖ-CE����뙎� 5��D���5m��nyMe��b�5�/-x)���Gȩ�����Q.ِӗ���NA��M��C���0<����Yk$���3�1m�s']0��B�_���v�(����9��}N�t�>����D�k*p�|`U�}��=�g�|�q���g؇?/a�ך���2k�e���7�PW�]k����̐a&`F?3w�|����T`��yK�du�=�V1�a��'J�TA�ɻ��~1�]����<ofjh�e5%�}_B�D�����mB���� �	�����f�$6�ׂ���}(HS=,)�NU��Q���a��8R	��-���B�
����l�b��aq�Z�����~a�n�����?��ԏtl��l�����;W�A5�X��4�빵��#.�p�������c��;dE����ݛ7o�Z5�            x������ � �            x������ � �            x������ � �            x������ � �          Q   x�3��+M-��2��/R�HLN-�2�t�S(�ON-��2�I-���KL��2�tN-*��8��@LsNלL��=... 4�      "   �  x����j1Fך��xн��oWJ�
d���B0�CڔR��W�.�~]��l�f�ù��L������x{}~���u�
������g�lM�������a\�5�OS\-	�������·�|���⣡�l7�10g���L&����?/�og2O�����~���F���O�l>�yd��&�+�| 9��$�@�ٓ�K�?�>}0H`8�!Cp��� N8� g	���sp��� .�� W	\��k�Y��V�l����a�,Җ]�_�BBJ�P�2�!�%i��֐І�7�#�qH�CI�qǁ;$�d���@�P�zr`	�(9D=9���E�4��<x��#Nq�G<b�'���#�ݑ������Xx�ɣ�a�����D����l��svG�F��6!��lt�� Q6�MHp(�&$(�Mo2�A��6!A�l~���O6�MH̐��&*
�D���)R2�D�)!n�b��7Q1HJ����$%�-�	�;%�MT�$7Qq�S��D�4)Yn��[Z����'%�MTpK�s�������1�����8W�(5�u�dR�\	��,WA!5ʕ@�GMr%�Q�\	g�W1E�W2Q�B�+���B�+��B��&��J&���J&��J&v��V2q�+ķ��C]!��L�N!��L��J&v��J&xTJn��8�?߮�      $   f  x��T[n�0��O����_� �$(�?�Ħ�eѠ�\�G�ź�F� (`��P��ٝ�<�ٳ}��÷���~�`{;�_�VgeVd�rzE�+V�Z0-e>�9ՌkI	-Ɣ�*c٣����|����c�|�ݵ`�����^=�n-m8��hShƗ�H�?�%��x������ٚ���o�Odk|�i���@7�W��}ܱv~w�o��s�\s��"ՌUEXPM���X�~
�ݚ�����j|p��~4�E�p�>]jLY����������iN���Bثi]c0荏ӘW�
��ćx�èsKO"z��3ml��sȂ[�T��KR��r,�B����$7G��w�k�=�c�o�>��þ����\$(�d"r��WD�*%����I"��ĥ"R&�br�ԔG��'���Lh]^��EYʇ��w4������`uג�eդ�,.qT�O.�2���'%�jj���8�m��	���_�BӜp1�y�<��*�2��q�t��V�]�*���K��SD�\؉��͢������V�_l��	���zXq��:g����-p0q��Kp�����TU8�`��YTc�3y*!S��WqJN�?�f���7yh      %      x������ � �      (   (   x���44��24�44�4�r���B\�& �%W� c�      *   #   x�3�t�)I�2��MM�L�2�tJ�J����� ^�H      ,     x�u�ͮ�0���SxǪ#��/�$t���eZ#��&U�^�s��c��Kt��F��7�Ǌ_/m7n������kB�.��ƀq�0�4Qypd��_����_(F�����0'>I�U��ס��6�^ۡ��V�s��J�KYF4�����:m�$����/�(j���V$�4f��MJ�ƷMW4���F2L��Ryc&4��g����`�=(���*���!��0��};�C�=�{��;�#����2���9��Y34)'8�!�[V|:��(P�]~&����ݳ��V��@�c���a�����nv��vR-����@������H����x����	��4��,>�:Ǩ27Y-��:D�A�IՈg�K�6��p��Z�yI8n�������U�W��O�ލ��bs�j戆�pwJ<嵼pe�~����m~	�.\��Z�aI��p:�Ѵ��S�s{��tR�X~3I��S(���}�d��=�y�����E��W&�ֆ�U&�p�S��@0W���|D~�\60�|��j�}f�      .   3   x�3�tL����,.)JL�/�2�tI-N,*����9�s2S�JR�b���� |��      0      x������ � �      2   *   x�3�HL)J�2������2�J�IL���KL������ ��	O      4   :   x�3�t>�2�4'Q!%U!9�4%1%1���D.#N?�.cd�Ԋ��ļ��"�|� �k�      6   N   x�3���,.�/�LTHIU-.M,���2�I,JM�2�(*MMJ�2�t-*�/�2�tN,JL.I-:���$39�+F��� \:      8   3   x�3��/�/*IU9�29/39�ˈ�9?��4�$�˘ӵ�(��+F��� I=�         �  x����N�@ƯO�g`�S�����b5�m���ک�@�jڷ�g�s
�QS�M&�����}�/`�x*r�P�Q^?��%Yѧ��+g�0�d���$oZXRQIڕ��Z���Y	��F&�M�� b;D��<Ҫ?��1���샅��P5oݹ�"�$TY�!���k�D��������ô����*���dY���;m���,�J�)�����wsI������;���5<���`�˶��a��=���OL�}�O�T�l9������)g�8g�MR������	�=��y�7�CĤP������92�0����(�g��f3bSB&����%q��^'�Յ/��bp� ����N��GV͵���2ׅ~"wL�9AAhkr`�^��r{�����oת�Jw4����&vk-�c9���u���ao��(     